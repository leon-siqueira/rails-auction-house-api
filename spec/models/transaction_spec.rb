# frozen_string_literal: true

# == Schema Information
#
# Table name: transactions
#
#  id            :bigint           not null, primary key
#  giver_type    :string
#  giver_id      :bigint
#  receiver_type :string
#  receiver_id   :bigint
#  amount        :integer
#  kind          :enum
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject { described_class.new(receiver:, giver:, amount:, kind:) }

  let(:amount) { 250 }
  giver_receivers = {
    deposit: { giver: nil, receiver: :user },
    withdrawal: { giver: :user, receiver: nil },
    bid: { giver: :user, receiver: :auction },
    covered_bid: { giver: :auction, receiver: :user },
    auction_income: { giver: :auction, receiver: :user }
  }

  describe 'receiver and giver validations GOOD ENDING' do
    giver_receivers.each do |transaction_kind, giver_receiver|
      context "when #{transaction_kind}" do
        giver_type = giver_receiver[:giver]
        receiver_type = giver_receiver[:receiver]
        let(:kind) { transaction_kind.to_s }
        let(:giver) { giver_type.nil? ? nil : create(giver_type) }
        let(:receiver) { receiver_type.nil? ? nil : create(receiver_type) }

        it "creates with no errors when giver type is #{giver_type.nil? ? 'nil' : giver_type} and receiver type is #{receiver_type.nil? ? 'nil' : receiver_type}" do
          expect(subject).to be_valid
          expect { subject.save }.to change { Transaction.all.count }.by(1)
        end
      end
    end
  end

  describe 'receiver and giver validations BAD ENDING' do
    let(:kind) { 'auction_income' }
    let(:giver) { nil }
    let(:receiver) { nil }

    it 'does not create and returns errors' do
      expect(subject).not_to be_valid
      expect { subject.save }.not_to(change { Transaction.all.count })
      expect(subject.errors.messages).to eq(receiver_type: ['is not suitable for this kind of transaction'], giver_type: ['is not suitable for this kind of transaction'])
    end
  end

  describe 'Bid transaction validations' do
    subject { described_class.new(receiver: auction, giver: user, amount:, kind: 'bid') }
    let(:user) { create(:user) }

    context 'bad ending:' do
      describe "when the user's balance isn't enough for the bid" do
        let(:user) { create(:user, balance: 0) }
        let(:amount) { 9999 }
        let(:auction) { create(:auction) }

        it "doesn't create the bid and returns an error" do
          expect { subject.save }.not_to(change { Transaction.all.count })
          expect(subject.errors.full_messages.first).to eq('Amount is greater than your current balance')
        end
      end

      describe 'when the auction is already over' do
        let(:auction) do
          a = build(:auction, start_date: Time.zone.now - 1.hour, end_date: Time.zone.now - 1.second)
          a.save(validate: false)
          a
        end
        let(:amount) { auction.minimal_bid }

        it "doesn't create the bid and returns an error" do
          expect { subject.save }.not_to(change { Transaction.all.count })
          expect(subject.errors.full_messages.first).to eq("Auction is already over. You can't place bids in it anymore")
        end
      end

      describe 'when the minimal bid is not reached' do
        let(:auction) { create(:auction) }
        let(:amount) { auction.minimal_bid - 1 }

        it "doesn't create the bid and returns an error" do
          expect { subject.save }.not_to(change { Transaction.all.count })
          expect(subject.errors.full_messages.first).to eq("Amount is less than the minimal bid setted for this auction: #{auction.minimal_bid}")
        end
      end

      describe 'when the bid does not surpass the winning bid value for at least 10' do
        let(:auction) { create(:auction) }
        let(:user2) { create(:user) }
        let(:amount) { 200 }

        before do
          create(:transaction, :bid, amount: auction.minimal_bid, receiver: auction, giver: user2)
        end

        it "doesn't create the bid and returns an error" do
          expect { subject.save }.not_to(change { Transaction.all.count })
          expect(subject.errors.full_messages.first).to eq("Amount needs to be greater than #{auction.winning_bid.amount + 10} to cover the currently winning bid")
        end
      end
    end
  end
end
