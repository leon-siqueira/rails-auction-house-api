# frozen_string_literal: true

# == Schema Information
#
# Table name: auctions
#
#  id          :bigint           not null, primary key
#  art_id      :bigint
#  description :string           default(""), not null
#  minimal_bid :integer
#  start_date  :datetime
#  end_date    :datetime
#  status      :enum
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#
class Auction < ApplicationRecord
  belongs_to :art
  belongs_to :user
  has_many :transactions, as: :receiver, inverse_of: :receiver, class_name: 'Transaction'
  has_many :transactions, as: :giver, inverse_of: :giver, class_name: 'Transaction'

  validates :art, presence: true, on: :create
  validates :start_date, comparison: { greater_than_or_equal_to: Time.zone.now }
  validates :end_date, comparison: { greater_than: :start_date }

  validate :existing_bids, on: :destroy

  enum :status, { scheduled: 'scheduled', in_progress: 'in_progress', finished: 'finished' }

  def bids
    Transaction.where(receiver: self, kind: 'bid')
  end

  def winning_bid
    bids.last
  end

  def existing_bids
    errors.add(:transactions, "Bids are already placed, you can't delete this auction anymore") if bids.any?
  end
end
