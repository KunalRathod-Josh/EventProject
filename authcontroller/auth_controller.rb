class AuthController < ApplicationController
  before_action :set_headers

  # Register action
  def register
    valid_roles = [ "Organizer", "Attendee" ]
    return render json: { error: "Invalid role" }, status: :unprocessable_entity unless valid_roles.include?(params[:role])

    role = Role.find_by(name: params[:role])
    user = User.new(user_params.merge(role_id: role.id))
    if user.save
      token = encode_token(user_id: user.id)
      render json: { user: user, token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Login action
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = encode_token(user_id: user.id)
      render json: { user: user, token: token, role: user.role.name }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  # Update (optional) - Update user profile
  def update
    user = User.find_by(id: params[:id])

    if user&.update(user_params)
      render json: { user: user }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Delete (optional) - Delete a user account
  def destroy
    user = User.find_by(id: params[:id])

    if user&.destroy
      render json: { message: "User deleted successfully" }, status: :ok
    else
      render json: { error: "Failed to delete user" }, status: :unprocessable_entity
    end
  end

  # Current user info
  def me
    user = current_user
    if user
      render json: { user: user, role: user.role.name }
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  private

  # Strong parameters for user input
  def user_params
    params.permit(:email, :password, :name, :organisation_name, :bio)
  end

  # Set headers for JSON response
  def set_headers
    request.format = :json
  end
end
