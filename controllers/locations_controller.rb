class LocationsController < ApplicationController
  before_action :set_location, only: [ :show, :update, :destroy ]
  load_and_authorize_resource

  def index
    @locations = Location.all
    render json: @locations
  end

  def show
    render json: @location
  end

  def create
    if @location.save
      render json: @location, status: :created
    else
      render json: { errors: @location.errors.full_messages }, status: :unprocessable_entity
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
end
