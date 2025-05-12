class BookingsController < ApplicationController
  before_action :set_booking, only: [ :show, :update, :destroy ]
  load_and_authorize_resource

  def index
    bookings = Booking.includes(:event).where(user_id: current_user.id)
    render json: bookings.as_json(include: { event: { only: [ :id, :title ] } })
  end

  def show
    render json: @booking
  end

  def create
    booking = Booking.build_with_logic(booking_params, current_user)

    if booking.save
      booking.event.update(capacity: booking.event.capacity - booking.quantity)
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
    params.require(:booking).permit(
      :event_id,
      :quantity,
      :discount_code,
      booking_guests_attributes: [ :name, :age, :id_proof ]
    )
  end
end
