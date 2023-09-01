require 'rails_helper'
require 'jwt'

RSpec.describe Auth do
  describe '.issue' do
    it 'encodes a payload into a JWT token' do
      payload = { user_id: 1, email: 'email@example.com' }
      token = Auth.issue(payload)

      expect(token).to be_a(String)
    end
  end

  describe '.decode' do
    it 'decodes a JWT token into a payload' do
      payload = { user_id: 1, email: 'email@example.com' }
      token = Auth.issue(payload)
      decoded_payload = Auth.decode(token)

      expect(decoded_payload.deep_symbolize_keys).to eq(payload)
    end

    it 'raises an error for an invalid token' do
      invalid_token = 'invalid_token'

      expect { Auth.decode(invalid_token) }.to raise_error(JWT::DecodeError)
    end
  end
end
