# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateBalanceJob, type: :job do
  subject(:update_balance) { described_class.perform_now(transaction) }

  describe '#perform' do
    before do
      allow(user).to receive(:update_balance)
    end

    context 'when the transaction is a deposit' do
      let(:transaction) { create(:transaction, :deposit) }
      let(:user) { transaction.receiver }

      it 'updates the user balance' do
        update_balance
        expect(user).to be_an_instance_of(User)
        expect(user).to have_received(:update_balance)
      end
    end

    context 'when the transaction is a withdrawal' do
      let(:transaction) { create(:transaction, :withdrawal) }
      let(:user) { transaction.giver }

      it 'updates the user balance' do
        update_balance
        expect(user).to be_an_instance_of(User)
        expect(user).to have_received(:update_balance)
      end
    end

    context 'when the transaction is a bid' do
      let(:transaction) { create(:transaction, :bid) }
      let(:user) { transaction.giver }

      it 'updates the user balance' do
        update_balance
        expect(user).to be_an_instance_of(User)
        expect(user).to have_received(:update_balance)
      end
    end

    context 'when the transaction is an auction income' do
      let(:transaction) { create(:transaction, :auction_income) }
      let(:user) { transaction.receiver }

      it 'updates the user balance' do
        update_balance
        expect(user).to be_an_instance_of(User)
        expect(user).to have_received(:update_balance)
      end
    end

    context 'when the transaction is a covered bid' do
      let(:transaction) { create(:transaction, :covered_bid) }
      let(:user) { transaction.receiver }

      it 'updates the user balance' do
        update_balance
        expect(user).to be_an_instance_of(User)
        expect(user).to have_received(:update_balance)
      end
    end
  end
end
