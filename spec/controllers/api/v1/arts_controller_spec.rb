# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ArtsController, type: :request do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:art) { create(:art, owner: user, creator: user) }

  describe 'Authorization' do
    context 'when the user is just logged in' do
      let(:issue_time) { Time.zone.now.to_i }
      let(:token) { JwtCodec.encode({ user_id: user.id, iat: issue_time, exp: Time.zone.now.to_i + 3600 }) }
      let(:params) do
        {
          art:
            { title: 'test',
              description: 'test',
              year: 2020,
              img_url: 'test' }
        }
      end

      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      it 'GET /api/v1/arts/:id shows an art' do
        get("/api/v1/arts/#{art.id}", headers:)
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data']['art']['id']).to eq(art.id)
      end

      it 'GET /api/v1/arts list all arts' do
        get('/api/v1/arts', headers:)
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data']).to be_an_instance_of(Array)
      end

      it 'POST /api/v1/arts does NOT allow to create if you do NOT have an artist role' do
        post('/api/v1/arts', params:, headers:)
        expect(response).to have_http_status(:forbidden)
        expect(response.parsed_body['error']).to eq('You are not authorized to perform this action')
      end

      it 'DELETE /api/v1/arts/:id does NOT allow to delete an art if you are NOT its creator AND owner NOR admin' do
        art.update(owner: user2)
        art.reload
        delete("/api/v1/arts/#{art.id}", headers:)
        expect(response).to have_http_status(:forbidden)
        expect(response.parsed_body['error']).to eq('You are not authorized to perform this action')
      end

      context 'when the user has an artist role' do
        let!(:artist_role) { create(:role, :artist, user:) }
        let!(:admin_role) { create(:role, :admin, user: user2) }
        let(:toker2) { JwtCodec.encode({ user_id: user2.id, iat: issue_time, exp: Time.zone.now.to_i + 3600 }) }
        let(:headers2) { { 'Authorization' => "Bearer #{toker2}" } }

        it 'POST /api/v1/arts allows to create an art' do
          post('/api/v1/arts', params:, headers:)
          expect(response).to have_http_status(:created)
          expect(response.parsed_body['success']).to be true
        end
      end

      context 'when the user has an admin role' do
        let!(:admin_role) { create(:role, :admin, user:) }

        it 'DELETE /api/v1/arts/:id allows to delete ANY art' do
          art.update(owner: user2)
          delete("/api/v1/arts/#{art.id}", headers:)
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body['success']).to be true
        end
      end
    end
  end
end
