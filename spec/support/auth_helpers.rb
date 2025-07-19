module AuthHelpers
  def auth_headers_for(user)
    token = jwt_token_for(user)
    puts "Generated token: #{token}" # Debug
    { 'Authorization' => "Bearer #{token}" }
  end

  def jwt_token_for(user)
    # Use a mesma estratégia que o Devise JWT
    payload = {
      sub: user.id.to_s,  # subject - padrão JWT
      scp: 'user',        # scope
      aud: nil,           # audience
      iat: Time.current.to_i,  # issued at
      exp: 1.day.from_now.to_i,  # expiration
      jti: SecureRandom.uuid      # JWT ID
    }
    JWT.encode(payload, ENV['DEVISE_JWT_SECRET_KEY'], 'HS256')
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end