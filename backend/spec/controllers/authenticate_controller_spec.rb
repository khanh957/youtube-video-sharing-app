require 'rails_helper'

RSpec.describe AuthenticateController do
  describe 'POST #login' do
    context 'when user exists and provides valid credentials' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        post :login, params: { email: 'email@example.com', password: 'password' }
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns user data and a token in the response' do
        response_body = JSON.parse(response.body)
        expect(response_body.dig('user', 'id')).to eq(user.id)
        expect(response_body.dig('user', 'email')).to eq(user.email)
        expect(response_body["token"]).to be_a(String)
      end
    end

    context 'when user does not exist' do
      before do
        post :login, params: { email: 'email@example.com', password: 'password' }
      end

      it 'creates a new user and returns new user data and a token in the response' do
        expect(response).to have_http_status(:created)

        response_body = JSON.parse(response.body)
        new_user = User.first
        expect(response_body.dig('user', 'id')).to eq(new_user.id)
        expect(response_body.dig('user', 'email')).to eq(new_user.email)
        expect(response_body["token"]).to be_a(String)
      end
    end

    context 'when user provides invalid credentials' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        post :login, params: { email: 'email@example.com', password: 'invalidpassword' }
      end

      it 'returns an unauthorized status code' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message in the response' do
        expect(JSON.parse(response.body)['error']).to eq('Invalid email or password')
      end
    end
  end
end
