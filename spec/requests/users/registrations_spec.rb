require 'rails_helper'

RSpec.describe 'User Registrations', type: :request do
  describe 'POST /signup' do
    let(:valid_params) do
      {
        registration: {
          first_name: 'John',
          last_name: 'Doe',
          email: 'john@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new user and returns JWT in header and user data' do
        expect {
          post '/signup', params: valid_params, as: :json
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Account created successfully')
        expect(json_response['data']).to include('user')
        expect(json_response['data']['user']['email']).to eq('john@example.com')

        expect(response.headers['Authorization']).to be_present
      end

      it 'returns valid JWT token in Authorization header' do
        post '/signup', params: valid_params, as: :json

        token = response.headers['Authorization']&.split(' ')&.last
        expect(token).to be_present

        decoded_token = JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY']).first
        expect(decoded_token['email']).to eq('john@example.com')
      end
    end

    context 'with invalid parameters' do
      it 'returns error for missing email' do
        params = valid_params.deep_dup
        params[:registration][:email] = ''

        post '/signup', params: params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('User could not be created')
        expect(json_response['errors']).to include("Email can't be blank")
      end

      it 'returns error for short password' do
        params = valid_params.deep_dup
        params[:registration][:password] = '123'
        params[:registration][:password_confirmation] = '123'

        post '/signup', params: params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Password is too short (minimum is 6 characters)")
      end

      it 'returns error for duplicate email' do
        create(:user, email: 'john@example.com')

        post '/signup', params: valid_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Email has already been taken")
      end
    end
  end
end
