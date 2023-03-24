require 'rails_helper'

RSpec.describe Bid, type: :model do
  subject { described_class.create(user:, auction:, value:) }
  let(:auction) { create(:auction) }
  let(:user) { create(:user) }

  context 'bad ending:' do
    describe "when the user's balance isn't enough for the bid" do
      let(:user) { create(:user, balance: 0) }
      let(:value) { 9999 }

      it "doesn't create the bid and returns an error" do
        expect(Bid.all.count).to eq 0
        expect(subject.errors.full_messages.first).to eq('Value is bigger than your current balance')
      end
    end

    describe 'when the auction is already over' do
      let(:auction) do
        a = build(:auction, start_date: Time.zone.now - 1.hour, end_date: Time.zone.now - 1.second)
        a.save(validate: false)
        a
      end
      let(:value) { auction.minimal_bid }

      it "doesn't create the bid and returns an error" do
        expect(Bid.all.count).to eq 0
        expect(subject.errors.full_messages.first).to eq("Auction is already over. You can't place bids in it anymore")
      end
    end

    describe 'when the minimal bid is not reached' do
      let(:auction) { create(:auction) }
      let(:value) { auction.minimal_bid - 1 }

      it "doesn't create the bid and returns an error" do
        expect(Bid.all.count).to eq 0
        expect(subject.errors.full_messages.first).to eq("Value is less than the minimal bid setted for this auction: #{auction.minimal_bid}")
      end
    end

    describe 'when the bid does not surpass the winning bid value for at least 10' do
      let(:auction) { create(:auction) }
      let(:value) { 200 }

      before do
        create(:bid, value: auction.minimal_bid, auction:)
      end

      it "doesn't create the bid and returns an error" do
        expect(Bid.all.count).to eq 1
        expect(subject.errors.full_messages.first).to eq("Value needs to be greater than #{auction.winning_bid.value + 10} to cover the currently winning bid")
      end
    end
  end
end
