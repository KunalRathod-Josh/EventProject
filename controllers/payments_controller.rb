class PaymentsController < ApplicationController
  before_action :authorize_request

  def create
    booking = Booking.find(params[:booking_id])

    payment = booking.build_payment(
      user_id: current_user.id,
      payment_method: params[:payment_method],
      amount: booking.total_amount,
      transaction_id: params[:transaction_id],
      status: "completed",
      payment_date: Time.current
    )

    if payment.save
      booking.event.increment!(:registered_count, booking.quantity)
      render json: { message: "Payment successful", payment_id: payment.id }, status: :ok
    else
      render json: { errors: payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def failure
    booking = Booking.find(params[:booking_id])

    payment = booking.build_payment(
      user_id: current_user.id,
      payment_method: params[:payment_method],
      amount: booking.total_amount,
      transaction_id: params[:transaction_id],
      status: "failed",
      payment_date: Time.current
    )

    if payment.save
      render json: { message: "Payment failed and recorded", payment_id: payment.id }, status: :ok
    else
      render json: { errors: payment.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
