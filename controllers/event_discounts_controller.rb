class EventDiscountsController < ApplicationController
  load_and_authorize_resource

  def index
    @event_discounts = if params[:event_id].present?
                         EventDiscount.where(event_id: params[:event_id])
    else
                         EventDiscount.all
    end

    render json: @event_discounts
  end

  def show
    render json: @event_discount.as_json(include: :event)
  end

  def update
    if @event_discount.update(event_discount_params)
      render json: @event_discount.as_json(include: :event)
    else
      render json: { errors: @event_discount.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @event_discount.destroy
      render json: { message: "Event discount deleted successfully" }
    else
      render json: { error: "Failed to delete event discount" }, status: :unprocessable_entity
    end
  end

  private

  def event_discount_params
    params.require(:event_discount).permit(
      :event_id,
      :name,
      :discount_type,
      :valid_until,
      :min_total_amount,
      :discount_value,
      :is_active
    )
  end
end
