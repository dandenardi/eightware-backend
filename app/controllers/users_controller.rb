class UsersController < ApplicationController
  before_action :authenticate_user!  # <- já fornecido pelo Devise

  def show
    render json: {
      message: 'User profile retrieved successfully',
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    }, status: :ok
  end
end
