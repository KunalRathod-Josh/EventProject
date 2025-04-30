class EventsController < ApplicationController
  before_action :require_organizer_or_admin, only: [ :destroy ]
  before_action :require_organizer, only: [ :create, :update, :destroy ]
  before_action :set_event, only: [ :show, :update, :destroy ]

  def index
    events = Event.includes(:location, :category, :event_discounts).all

    events_with_banners = events.map do |event|
      {
        id: event.id,
        title: event.title,
        description: event.description,
        start_datetime: event.start_datetime,
        end_datetime: event.end_datetime,
        location: event.location,
        category: event.category,
        event_discounts: event.event_discounts,
        base_ticket_price: event.base_ticket_price,
        capacity: event.capacity,
        is_early_bird_active: event.is_early_bird_active,
        is_amount_discount_active: event.is_amount_discount_active,
        banner_url: event.banner.attached? ? url_for(event.banner) : nil
      }
    end

    render json: events_with_banners
  end


  def show
    render json: {
      id: @event.id,
      title: @event.title,
      description: @event.description,
      start_datetime: @event.start_datetime,
      end_datetime: @event.end_datetime,
      location: @event.location,
      category: @event.category,
      event_discounts: @event.event_discounts,
      base_ticket_price: @event.base_ticket_price,
      capacity: @event.capacity,
      is_early_bird_active: @event.is_early_bird_active,
      is_amount_discount_active: @event.is_amount_discount_active,
      banner_url: @event.banner.attached? ? url_for(@event.banner) : nil
    }
  end


  def create
    event = Event.find(params[:booking][:event_id])
    quantity = params[:booking][:quantity].to_i
    discount_code = params[:booking][:discount_code]

    return render json: { error: "Invalid quantity" }, status: :unprocessable_entity if quantity <= 0
    return render json: { error: "Not enough tickets available" }, status: :unprocessable_entity if event.capacity < quantity

    base_price = event.base_ticket_price.to_f
    total_price = base_price * quantity
    applied_discount = nil

    if discount_code.present?
      discount = event.event_discounts.find_by(name: discount_code, is_active: true)
      return render json: { error: "Invalid or inactive discount code" }, status: :unprocessable_entity unless discount

      total_price -= total_price * (discount.discount_value.to_f / 100.0)
      applied_discount = discount.name
    end

    Booking.transaction do
      event = Event.lock.find(params[:booking][:event_id])

      if event.capacity >= quantity
        booking = Booking.new(booking_params.merge(
          user_id: current_user.id,
          total_price: total_price.round(2),
          discount_applied: applied_discount
        ))

        if booking.save
          event.update!(capacity: event.capacity - quantity)

          render json: booking.as_json(include: { booking_guests: { only: [ :id, :name, :age ] } }), status: :created
        else
          render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
        end
      else
        raise ActiveRecord::Rollback, "Not enough tickets available"
      end
    end
  rescue ActiveRecord::Rollback => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def update
    if @event.update(event_params)
      render json: @event, include: [ :location, :category, :event_discounts ]
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    render json: { message: "Event deleted successfully" }
  end

  private

  def set_event
    @event = Event.find_by(id: params[:id])
    render json: { error: "Event not found" }, status: :not_found unless @event
  end

  def event_params
    params.require(:event).permit(
      :start_datetime,
      :end_datetime,
      :title,
      :description,
      :location_id,
      :category_id,
      :base_ticket_price,
      :capacity,
      :is_early_bird_active,
      :is_amount_discount_active,
      event_discounts_attributes: [
        :name, :discount_type, :discount_value,
        :min_total_amount, :valid_until, :is_active
      ],
      banner: []
    )
  end

  def require_organizer
    unless current_user&.role&.name == "Organizer"
      render json: { error: "Only organizers can perform this action" }, status: :unauthorized
    end
  end

  def require_organizer_or_admin
    unless [ "Organizer", "Admin" ].include?(current_user&.role&.name)
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
