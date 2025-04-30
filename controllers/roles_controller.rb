class RolesController < ApplicationController
  before_action :authorize_admin
  before_action :set_role, only: [ :show, :update, :destroy ]

  def index
    roles = Role.all
    render json: roles
  end

  def show
    render json: @role
  end

  def create
    role = Role.new(role_params)
    if role.save
      render json: role, status: :created
    else
      render json: { errors: role.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @role.update(role_params)
      render json: @role
    else
      render json: { errors: @role.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @role.destroy
    render json: { message: "Role deleted successfully" }
  end

  private

  def authorize_admin
    unless current_user&.role&.name == "Admin"
      render json: { error: "Access denied" }, status: :unauthorized
    end
  end

  def set_role
    @role = Role.find_by(id: params[:id])
    render json: { error: "Role not found" }, status: :not_found unless @role
  end

  def role_params
    params.require(:role).permit(:name)
  end
end
