class ApplicationController < ActionController::API
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  respond_to :json

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  def current_user
    @current_user ||= super || User.find(decoded_token[:user_id]) if decoded_token
  end

  def decoded_token
    @decoded_token ||= JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY']).first if token
  rescue JWT::DecodeError
    nil
  end

  def token
    @token ||= request.headers['Authorization']&.split(' ')&.last
  end

  def render_error(message, status = :unprocessable_entity)
    render json: { error: message }, status: status
  end

  def render_success(data, message = 'Success')
    render json: { message: message, data: data }, status: :ok
  end
end