class HealthController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render json: { 
      status: 'ok', 
      timestamp: Time.current,
      version: '1.0.0'
    }, status: :ok
  end
end