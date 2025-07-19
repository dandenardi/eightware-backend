require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /me' do
    let(:user) { create(:user, password: 'password123') }

    context 'with valid token' do
      it 'returns user profile' do
        # Faz login real para obter token JWT válido
        post '/login', params: {
          user: {
            email: user.email,
            password: 'password123'
          }
        }, as: :json
        
        # Verifica se o login funcionou
        expect(response).to have_http_status(:ok)
        token = response.headers['Authorization']
        expect(token).to be_present
        
        # Usa o token obtido do login
        get '/me', headers: { 'Authorization' => token }

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('User profile retrieved successfully')
        expect(json_response['data']['email']).to eq(user.email)
      end
    end

    context 'without token' do
      it 'returns unauthorized error' do
        get '/me'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid token' do
      it 'returns unauthorized error' do
        get '/me', headers: { 'Authorization' => 'Bearer invalid-token' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end