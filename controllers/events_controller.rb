class EventsController < ApplicationController
  load_and_authorize_resource

  def index
    render json: @events.includes(:location, :category, :event_discounts).map(&:full_details)
  end

  def show
    render json: @event.full_details
  end

  def create
    @event.organizer = current_user if current_user.organizer?

    if @event.save
      render json: { message: "Event created successfully", event: @event.full_details }, status: :created
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render json: @event.full_details
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    render json: { message: "Event deleted successfully" }
  end

  private

  def event_params
    params.require(:event).permit(
      :title,
      :description,
      :start_datetime,
      :end_datetime,
      :base_ticket_price,
      :capacity,
      :category_id,
      :location_id,
      :is_early_bird_active,
      :is_amount_discount_active,
      :banner,
      event_discounts_attributes: [
        :name,
        :discount_type,
        :discount_value,
        :valid_until,
        :min_total_amount,
        :is_active
      ]
    )
  end
end
