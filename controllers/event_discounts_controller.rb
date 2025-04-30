class EventDiscountsController < ApplicationController
  before_action :require_organizer, only: [ :update, :destroy ]
  before_action :set_event_discount, only: [ :show, :update, :destroy ]

  def index
    if params[:event_id].present?
      @event_discounts = EventDiscount.where(event_id: params[:event_id])
    else
      @event_discounts = EventDiscount.all
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

  def set_event_discount
    @event_discount = EventDiscount.find_by(id: params[:id])
    render json: { error: "Event discount not found" }, status: :not_found unless @event_discount
  end

  def event_discount_params
    params.require(:event_discount).permit(:event_id, :discount_type, :valid_until, :min_total_amount, :discount_value, :is_active)
  end

  def require_organizer
    unless current_user&.role&.name == "Organizer"
      render json: { error: "Only organizers can perform this action" }, status: :unauthorized
    end
  end
end
