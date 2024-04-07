require 'rails_helper'

RSpec.describe Api::V1::AuctionsController, type: :request do
  let(:user) { create(:user) }
  let!(:art) { create(:art, owner: user, creator: user) }

  describe 'Authorization' do
    context 'when the user is just logged in' do
      let(:issue_time) { Time.zone.now.to_i }
      let(:token) { JwtCodec.encode({ user_id: user.id, iat: issue_time, exp: Time.zone.now.to_i + 3600 }) }
      let(:params) do
        {
          auction: {
            art_id: art.id,
            minimal_bid: 200,
            end_date: Time.zone.now + 1.hour
          }
        }
      end
      let!(:auction) { create(:auction) }

      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      it 'GET /api/v1/auctions/:id shows an auction' do
        get("/api/v1/auctions/#{auction.id}", headers:)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data']['auction']['id']).to eq(auction.id)
      end

      it 'GET /api/v1/auctions list all auctions' do
        get('/api/v1/auctions', headers:)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data']).to be_an_instance_of(Array)
      end

      it 'POST /api/v1/auctions does NOT allow to create if you do NOT have an auctioneer role NOR admin' do
        post('/api/v1/auctions', params:, headers:)
        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)['error']).to eq('You are not authorized to perform this action')
      end

      it 'DELETE /api/v1/auctions/:id does NOT allow to delete if you do NOT have an auctioneer role NOR admin' do
        delete("/api/v1/auctions/#{auction.id}", headers:)
        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)['error']).to eq('You are not authorized to perform this action')
      end
    end
  end
end
