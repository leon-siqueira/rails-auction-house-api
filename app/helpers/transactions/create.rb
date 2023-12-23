# frozen_string_literal: true

module Transactions
  # Create transaction avoiding verbose code in controllers
  class Create
    def initialize(kind, params)
      @kind = kind
      @params = params.merge({ kind: })
    end

    def call
      transaction = create_by_kind

      if transaction.save
        { success: true, transaction: }
      else
        { success: false, errors: transaction.errors }
      end
    end

    private

    def create_by_kind
      case @kind
      when 'bid'
        Transaction.new(@params.merge({ giver_type: 'User', receiver_type: 'Auction' }))
      when 'auction_income', 'covered_bid'
        Transaction.new(@params.merge({ receiver_type: 'User', giver_type: 'Auction' }))
      when 'withdrawal'
        Transaction.new(@params.merge({ giver_type: 'User' }))
      when 'deposit'
        Transaction.new(@params.merge({ receiver_type: 'User' }))
      end
    end
  end
end
