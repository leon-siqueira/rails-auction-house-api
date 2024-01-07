# == Schema Information
#
# Table name: transactions
#
#  id            :bigint           not null, primary key
#  giver_type    :string
#  giver_id      :bigint
#  receiver_type :string           not null
#  receiver_id   :bigint           not null
#  amount        :integer
#  kind          :enum
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Transaction < ApplicationRecord
  belongs_to :giver, polymorphic: true, optional: -> { kind == 'deposit' }
  belongs_to :receiver, polymorphic: true, optional: -> { kind == 'withdrawal' }

  KINDS = { deposit: 'deposit', withdrawal: 'withdrawal', auction_income: 'auction_income',
            bid: 'bid', covered_bid: 'covered_bid' }.freeze

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :kind, presence: true, inclusion: { in: KINDS.values }

  validate :allowed_receivers_per_kind
  validate :allowed_givers_per_kind

  validate :auction_in_progress, if: -> { kind == 'bid' }
  validate :minimal_bid_reached, if: -> { kind == 'bid' }
  validate :winning_bid_covered, if: -> { kind == 'bid' }
  validate :enough_balance, if: -> { giver_type == 'User' }

  enum :kind, KINDS

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
    return unless receiver.bids.any? && (receiver < receiver.winning_bid.value + 10)

    errors.add(:amount,
               "needs to be greater than #{receiver.winning_bid.value + 10} to cover the currently winning bid")
  end

  def enough_balance
    return unless giver.balance <= amount

    errors.add(:amount, 'is greater than your current balance')
  end
end
