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
end
