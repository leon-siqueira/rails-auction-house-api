# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BidsController, type: :request do
  let(:user) { create(:user) }
  let!(:auction) { create(:auction) }
  let!(:bid) { create(:transaction, :bid, amount: 300, giver: user, receiver: auction) }

  describe 'Authorization' do
    context 'when the user is just logged in' do
      let(:issue_time) { Time.zone.now.to_i }
      let(:token) { JwtCodec.encode({ user_id: user.id, iat: issue_time, exp: Time.zone.now.to_i + 3600 }) }
      let(:params) do
        {
          bid:
            { auction_id: auction.id,
              amount: 350 }
        }
      end

      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      it 'GET /api/v1/bids/:id shows a bid' do
        get("/api/v1/bids/#{bid.id}", headers:)
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data']['bid']['id']).to eq(bid.id)
      end

      it 'GET /api/v1/auctions/:id/bids list all bids on that auction' do
        bid
        get("/api/v1/auctions/#{auction.id}/bids", headers:)
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data']).to be_an_instance_of(Array)
      end

      it 'POST /api/v1/bids does NOT allow to create if you do NOT have an buyer role' do
        post('/api/v1/bids', params:, headers:)
        expect(response).to have_http_status(:forbidden)
        expect(response.parsed_body['error']).to eq('You are not authorized to perform this action')
      end

      context 'when the user has an buyer role' do
        before { create(:role, :buyer, user:) }

        it 'POST /api/v1/bids allows you to create a bid on auctions that were NOT created by you' do
          post('/api/v1/bids', params:, headers:)
          expect(response).to have_http_status(:created)
          expect(response.parsed_body['success']).to be true
        end

        it 'POST /api/v1/bids DOES NOT allow you to create a bid on auctions that were created by you' do
          auction.update(user:)
          auction.reload
          post('/api/v1/bids', params:, headers:)
          expect(response).to have_http_status(:forbidden)
          expect(response.parsed_body['error']).to eq('You are not authorized to perform this action')
        end
      end

      context 'when the user has an admin role' do
        before { create(:role, :admin, user:) }

        it 'POST /api/v1/bids allows you to create a bid on ANY auction' do
          post('/api/v1/bids', params:, headers:)
          expect(response).to have_http_status(:created)
          expect(response.parsed_body['success']).to be true
        end
      end
    end
  end
end
