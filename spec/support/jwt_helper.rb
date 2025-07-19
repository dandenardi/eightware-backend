module JwtHelper
  def jwt_token_for(user)
    payload = { user_id: user.id, email: user.email, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, ENV['DEVISE_JWT_SECRET_KEY'])
  end

  def auth_headers_for(user)
    token = jwt_token_for(user)
    { 'Authorization' => "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include JwtHelper, type: :request
end