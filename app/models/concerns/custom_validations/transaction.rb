module CustomValidations
  module Transaction
    extend ActiveSupport::Concern

    included do
      private

      def allowed_receivers_per_kind
        valid = case kind
                when 'deposit', 'auction_income', 'covered_bid'
                  receiver_type == 'User'
                when 'bid'
                  receiver_type == 'Auction'
                when 'withdrawal'
                  receiver_type.nil?
                end

        errors.add(:receiver_type, 'is not suitable for this kind of transaction') unless valid
      end

      def allowed_givers_per_kind
        valid = case kind
                when 'withdrawal', 'bid'
                  giver_type == 'User'
                when 'auction_income', 'covered_bid'
                  giver_type == 'Auction'
                when 'deposit'
                  giver_type.nil?
                end

        errors.add(:giver_type, 'is not suitable for this kind of transaction') unless valid
      end

      def auction_in_progress
        return unless Time.zone.now > receiver.end_date

        errors.add(:auction, "is already over. You can't place bids in it anymore")
      end

      def minimal_bid_reached
        return unless receiver.bids.empty? && (amount < receiver.minimal_bid)

        errors.add(:amount, "is less than the minimal bid setted for this auction: #{receiver.minimal_bid}")
      end

      def winning_bid_covered
        return unless receiver.bids.any? && (amount < receiver.winning_bid.amount + 10)

        errors.add(:amount,
                   "needs to be greater than #{receiver.winning_bid.amount + 10} to cover the currently winning bid")
      end

      def enough_balance
        return unless giver.balance <= amount

        errors.add(:amount, 'is greater than your current balance')
      end
    end
  end
end
