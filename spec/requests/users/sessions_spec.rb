require 'rails_helper'

RSpec.describe 'User Sessions', type: :request do
  describe 'POST /login' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    context 'with valid credentials' do
      it 'returns JWT token in Authorization header and user data' do
        post '/login', params: {
          user: {
            email: 'test@example.com',
            password: 'password123'
          }
        }, as: :json

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Logged in successfully')
        expect(json_response['data']).to include('user')
        expect(json_response['data']['user']['email']).to eq('test@example.com')

        expect(response.headers['Authorization']).to be_present
      end

      it 'returns a valid JWT token' do
        post '/login', params: {
          user: {
            email: 'test@example.com',
            password: 'password123'
          }
        }, as: :json

        token = response.headers['Authorization']&.split(' ')&.last
        expect(token).to be_present

        decoded_token = JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY']).first
        expect(decoded_token['user_id']).to eq(user.id)
        expect(decoded_token['email']).to eq(user.email)
      end
    end

    context 'with invalid credentials' do
      it 'returns error for wrong password' do
        post '/login', params: {
          user: {
            email: 'test@example.com',
            password: 'wrongpassword'
          }
        }, as: :json

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error for non-existent user' do
        post '/login', params: {
          user: {
            email: 'nonexistent@example.com',
            password: 'password123'
          }
        }, as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
