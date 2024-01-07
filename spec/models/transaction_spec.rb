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
      expect { subject.save }.not_to change { Transaction.all.count }
      expect(subject.errors.messages).to eq(receiver_type: ['is not suitable for this kind of transaction'], giver_type: ['is not suitable for this kind of transaction'])
    end
  end
end
