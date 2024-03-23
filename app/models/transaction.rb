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
class Transaction < ApplicationRecord
  include CustomValidations::Transaction

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

  after_create -> { UpdateBalanceJob.perform_later(self) }

  enum :kind, KINDS
end
