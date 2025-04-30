class BookingsController < ApplicationController
  before_action :require_attendee, only: [ :index, :show, :create ]
  before_action :set_booking, only: [ :show, :update, :destroy ]

  def index
    bookings = Booking.includes(:event).where(user_id: current_user.id)
    render json: bookings.as_json(include: { event: { only: [ :id, :title ] } })
  end

  def show
    render json: @booking
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

    booking = Booking.new(booking_params.merge(
      user_id: current_user.id,
      total_price: total_price.round(2),
      discount_applied: applied_discount
    ))

    if booking.save
      event.update(capacity: event.capacity - quantity)
      render json: booking.as_json(include: { booking_guests: { only: [ :id, :name, :age ] } }), status: :created
    else
      render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @booking.update(booking_params)
      render json: @booking
    else
      render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @booking.destroy
      render json: { message: "Booking deleted successfully" }
    else
      render json: { error: "Failed to delete booking" }, status: :unprocessable_entity
    end
  end

  private

  def set_booking
    @booking = Booking.find_by(id: params[:id])
    render json: { error: "Booking not found" }, status: :not_found unless @booking
  end

  def booking_params
    params.require(:booking).permit(:event_id, :quantity, :status, :discount_code, booking_guests_attributes: [ :name, :age, :id_proof ])
  end

  def require_attendee
    unless current_user&.role&.name == "Attendee"
      render json: { error: "Only attendees can perform this action" }, status: :unauthorized
    end
  end
end
