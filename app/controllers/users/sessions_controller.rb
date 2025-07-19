class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource) # ✅ Garante emissão do JWT
    respond_with(resource, {})
  end

  private

  def respond_with(resource, _opts = {})
    render json: {
      message: 'Logged in successfully',
      data: {
        user: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end
