class LocationsController < ApplicationController
  before_action :authorize_admin, only: [ :create, :update, :destroy ]
  before_action :set_location, only: [ :show, :update, :destroy ]

  def index
    locations = Location.all
    render json: locations
  end

  def show
    render json: @location
  end

  def create
    location = Location.new(location_params)
    if location.save
      render json: location, status: :created
    else
      render json: { errors: location.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @location.update(location_params)
      render json: @location
    else
      render json: { errors: @location.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @location
      @location.destroy
      render json: { message: "Location deleted successfully" }
    else
      render json: { error: "Location not found" }, status: :not_found
    end
  end

  private

  def set_location
    @location = Location.find_by(id: params[:id])
    render json: { error: "Location not found" }, status: :not_found unless @location
  end

  def location_params
    params.require(:location).permit(:name, :address, :city, :pin_code)
  end

  def authorize_admin
    unless current_user&.role&.name == "Admin"
      render json: { error: "Access denied" }, status: :unauthorized
    end
  end
end
