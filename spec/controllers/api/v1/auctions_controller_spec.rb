require 'rails_helper'

RSpec.describe Api::V1::AuctionsController, type: :request do
  let(:user) { create(:user) }
  let!(:art) { create(:art, owner: user, creator: user) }
  let!(:auction) { create(:auction) }

  describe 'Authorization' do
    context 'when the user is just logged in' do
      let(:issue_time) { Time.zone.now.to_i }
      let(:token) { JwtCodec.encode({ user_id: user.id, iat: issue_time, exp: Time.zone.now.to_i + 3600 }) }
      let(:params) do
        {
          art_id: art.id,
          minimal_bid: 200,
          end_date: Time.zone.now + 1.hour
        }
      end

      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      it 'GET /api/v1/auctions/:id shows an art' do
        get("/api/v1/auctions/#{auction.id}", headers:)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data']['auction']['id']).to eq(auction.id)
      end

      it 'GET /api/v1/auctions list all arts' do
        get('/api/v1/auctions', headers:)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data']).to be_an_instance_of(Array)
      end
    end
  end
end
