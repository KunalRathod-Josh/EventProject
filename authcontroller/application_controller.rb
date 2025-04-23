class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def encode_token(payload)
    payload[:exp] = 24.hours.from_now.to_i  # Token expires in 24 hours
    JWT.encode(payload, Rails.application.secret_key_base)
  end

  def decode_token
    auth_header = request.headers["Authorization"]
    if auth_header
      token = auth_header.split(" ")[1]
      begin
        JWT.decode(token, Rails.application.secret_key_base, true, algorithm: "HS256")
      rescue JWT::ExpiredSignature, JWT::DecodeError
        nil
      end
    end
  end


  def current_user
    decoded = decode_token
    if decoded
      user_id = decoded[0]["user_id"]
      @current_user ||= User.find_by(id: user_id)
    end
  end

  def authorize_request
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end

  def require_admin
    render json: { error: "Forbidden" }, status: :forbidden unless current_user&.role&.name == "Admin"
  end

  def require_organizer
    render json: { error: "Forbidden" }, status: :forbidden unless current_user&.role&.name == "Organizer"
  end

  def require_attendee
    render json: { error: "Forbidden" }, status: :forbidden unless current_user&.role&.name == "Attendee"
  end
end
