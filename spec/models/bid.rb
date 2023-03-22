require 'rails_helper'

RSpec.describe Bid, type: :model do
  subject { described_class.create(user:, auction:, value:) }
  let(:auction) { create(:auction) }

  describe 'bad ending:' do
    describe "when the user's balance isn't enough for the bid" do
      let!(:user) { create(:user, balance: 0) }
      let!(:value) { 9999 }

      it "doesn't create the bid and returns an error" do
        expect(Bid.all.count).to eq 0
        expect(subject.errors.full_messages.first).to eq('Value is bigger than your current balance')
      end
    end
  end
end
