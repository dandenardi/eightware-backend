class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def sign_up_params
    params.require(:registration).permit(
      :email,
      :password,
      :password_confirmation,
      :first_name,
      :last_name
    )
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        message: 'Account created successfully',
        data: {
          user: UserSerializer.new(resource).serializable_hash[:data][:attributes]
        }
      }, status: :created
    else
      render json: {
        message: 'User could not be created',
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
end
