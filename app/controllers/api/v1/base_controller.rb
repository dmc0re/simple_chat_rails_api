class API::V1::BaseController < ActionController::Base
  protect_from_forgery with: :null_session

  respond_to :json

  # Devise methods overwrites
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])  #TODO: use Devise.secure_compare instead
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated" }, status: :unauthorized unless user_signed_in?
  end

  def user_signed_in?
    current_user.present? 
  end
end