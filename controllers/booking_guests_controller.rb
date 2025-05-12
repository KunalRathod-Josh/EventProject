class BookingGuestsController < ApplicationController
  before_action :set_booking_guest, only: [ :show, :update, :destroy ]
  load_and_authorize_resource

  def index
    booking_guests = BookingGuest.includes(:booking).all

    render json: booking_guests.map { |guest|
      guest.as_json(only: [ :id, :name, :age, :booking_id ]).merge(
        id_proof_url: guest.id_proof.attached? ? url_for(guest.id_proof) : nil,
        booking: guest.booking.as_json(only: [ :id, :user_id, :event_id ])
      )
    }
  end

  def show
    render json: @booking_guest.as_json(only: [ :id, :name, :age, :booking_id ]).merge(
      id_proof_url: @booking_guest.id_proof.attached? ? url_for(@booking_guest.id_proof) : nil,
      booking: @booking_guest.booking.as_json(only: [ :id, :user_id, :event_id ])
    )
  end

  def create
    booking_guest = BookingGuest.new(booking_guests_params)
    booking_guest.id_proof.attach(params[:booking_guest][:id_proof]) if params[:booking_guest][:id_proof].present?

    if booking_guest.save
      render json: booking_guest.as_json(only: [ :id, :name, :age, :booking_id ]).merge(
        id_proof_url: booking_guest.id_proof.attached? ? url_for(booking_guest.id_proof) : nil
      ), status: :created
    else
      render json: { errors: booking_guest.errors.full_messages }, status: :unprocessable_entity
    end
  end



  def update
    if @booking_guest.update(booking_guests_params)
      render json: @booking_guest.as_json(only: [ :id, :name, :age, :booking_id ]).merge(
        id_proof_url: @booking_guest.id_proof.attached? ? url_for(@booking_guest.id_proof) : nil
      )
    else
      render json: { errors: @booking_guest.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @booking_guest.destroy
    head :no_content
  end

  private

  def booking_guests_params
    params.require(:booking_guest).permit(:booking_id, :name, :age, :id_proof)
  end

  def set_booking_guest
    @booking_guest = BookingGuest.find_by(id: params[:id])
    render json: { error: "Booking guest not found" }, status: :not_found unless @booking_guest
  end
end
