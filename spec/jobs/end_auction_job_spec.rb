# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EndAuctionJob, type: :job do
  include ActiveJob::TestHelper
  subject(:end_auction) { described_class.perform_now(auction) }

  describe '#perform' do
    let(:auction) { create(:auction) }
    let(:original_art_owner) { auction.art.owner }

    context 'when the auction has no bids' do
      it 'ends the auction with no further consequences' do
        expect { end_auction }.to change(auction, :status).from('in_progress').to('finished')
        expect(auction.reload.art.owner).to eq(original_art_owner)
      end
    end

    context 'when the auction has bids' do
      let(:loser_bid) { create(:transaction, :bid, receiver: auction, amount: 100) }
      let(:winner_bid) { create(:transaction, :bid, receiver: auction, amount: 200) }

      it 'ends the auction, repays bid value to the auction owner and transfers the art to the highest bidder' do
        expect { end_auction }.to change(auction, :status).from('in_progress').to('finished')
                              .and change(Transaction, :count).by(1)
                              .and change(auction.art, :owner).from(original_art_owner).to(bid2.giver)
      end
    end
  end
end
