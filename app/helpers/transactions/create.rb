# frozen_string_literal: true

module Transactions
  # Create transaction avoiding verbose code in controllers
  class Create
    class << self
      def call(kind, params)
        params.merge!({ kind: })
        transaction = create_by_kind(kind, params)

        if transaction.save
          { success: true, transaction: }
        else
          { success: false, errors: transaction.errors }
        end
      end

      private

      def create_by_kind(kind, params)
        case kind
        when 'bid'
          Transaction.new(params.merge({ giver_type: 'User', receiver_type: 'Auction' }))
        when 'auction_income', 'covered_bid'
          Transaction.new(params.merge({ receiver_type: 'User', giver_type: 'Auction' }))
        when 'withdrawal'
          Transaction.new(params.merge({ giver_type: 'User' }))
        when 'deposit'
          Transaction.new(params.merge({ receiver_type: 'User' }))
        end
      end
    end
  end
end
