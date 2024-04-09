# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request do
  let(:user) { create(:user) }

  describe 'DELETE api/v1/session' do
    context 'when the user is logged in' do
      let(:issue_time) { Time.zone.now.to_i }
      let(:token) { JwtCodec.encode({ user_id: user.id, iat: issue_time, exp: Time.zone.now.to_i + 3600 }) }
      let(:params) { { art: { title: 'test', description: 'test', price: 100, image: 'test' } } }

      it 'updates user.token_expiration and does NOT allow auth-dependant actions to be done' do
        headers = { 'Authorization' => "Bearer #{token}" }
        expect(user.token_expiration).to be_nil

        sleep 1

        delete('/api/v1/sessions', headers:)
        expect(response.status).to eq(200)
        user.reload
        expect(user.token_expiration.to_i > issue_time).to eq true

        post('/api/v1/arts', params:, headers:)
        expect(response.status).to eq(401)
      end
    end
  end
end
