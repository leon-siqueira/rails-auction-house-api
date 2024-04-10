# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuctionsController, type: :request do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:bid) { create(:transaction, :bid, receiver: auction, giver: user2, amount: auction.minimal_bid) }
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
            end_date: 1.hour.from_now
          }
        }
      end
      let!(:auction) { create(:auction) }

      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      it 'GET /api/v1/auctions/:id shows an auction' do
        get("/api/v1/auctions/#{auction.id}", headers:)
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data']['auction']['id']).to eq(auction.id)
      end

      it 'GET /api/v1/auctions list all auctions' do
        get('/api/v1/auctions', headers:)
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data']).to be_an_instance_of(Array)
      end

      it 'POST /api/v1/auctions does NOT allow to create if you do NOT have an auctioneer role NOR admin' do
        post('/api/v1/auctions', params:, headers:)
        expect(response).to have_http_status(:forbidden)
        expect(response.parsed_body['error']).to eq('You are not authorized to perform this action')
      end

      it 'DELETE /api/v1/auctions/:id does NOT allow to delete if you do NOT have an auctioneer role NOR admin' do
        delete("/api/v1/auctions/#{auction.id}", headers:)
        expect(response).to have_http_status(:forbidden)
        expect(response.parsed_body['error']).to eq('You are not authorized to perform this action')
      end

      context 'when the user has an auctioneer role' do
        before { create(:role, :auctioneer, user:) }

        it 'POST /api/v1/auctions with an art THAT YOU OWN, it allows to create an auction' do
          post('/api/v1/auctions', params:, headers:)
          expect(response).to have_http_status(:created)
          expect(response.parsed_body['success']).to be true
        end

        it 'POST /api/v1/auctions with an art THAT YOU DO NOT OWN, it does NOT allows to create an auction' do
          art.update(owner: user2)
          art.reload
          post('/api/v1/auctions', params:, headers:)
          expect(response).to have_http_status(:forbidden)
          expect(response.parsed_body['error']).to eq('You are not authorized to perform this action')
        end

        it 'DELETE /api/v1/auctions with an auction THAT YOU OWN with no bids, it allows to delete an auction' do
          delete("/api/v1/auctions/#{auction.id}", params:, headers:)
          expect(response).to have_http_status(:forbidden)
          expect(response.parsed_body['error']).to eq('You are not authorized to perform this action')
        end

        it 'DELETE /api/v1/auctions with an auction THAT YOU OWN with ANY bids, it does NOT allows to delete an auction' do
          bid
          auction.reload
          delete("/api/v1/auctions/#{auction.id}", params:, headers:)
          expect(response).to have_http_status(:forbidden)
          expect(response.parsed_body['error']).to eq('You are not authorized to perform this action')
        end

        it 'DELETE /api/v1/auctions with an auction THAT YOU DO NOT OWN, it does NOT allows to create an auction' do
          art.update(owner: user2)
          art.reload
          delete("/api/v1/auctions/#{auction.id}", params:, headers:)
          expect(response).to have_http_status(:forbidden)
          expect(response.parsed_body['error']).to eq('You are not authorized to perform this action')
        end
      end

      context 'when the user has an admin role' do
        before { create(:role, :admin, user:) }

        it 'DELETE /api/v1/auctions/:id allows to delete ANY auction' do
          bid
          art.update(owner: user2)
          delete("/api/v1/auctions/#{auction.id}", headers:)
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body['success']).to be true
        end
      end
    end
  end
end
