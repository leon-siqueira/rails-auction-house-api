# == Schema Information
#
# Table name: bids
#
#  id         :bigint           not null, primary key
#  auction_id :bigint           not null
#  user_id    :bigint           not null
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Bid < ApplicationRecord
  belongs_to :auction
  belongs_to :user

  validate :auction_in_progress
  validate :minimal_bid_reached
  validate :winning_bid_covered
  validate :enough_balance

  def auction_in_progress
    return unless Time.zone.now > auction.end_date

    errors.add(:auction, "is already over. You can't place bids in it anymore")
  end

  def minimal_bid_reached
    return unless auction.bids.empty? && (value < auction.minimal_bid)

    errors.add(:value, "is less than the minimal bid setted for this auction: #{auction.minimal_bid}")
  end

  def winning_bid_covered
    return unless auction.bids.any? && (value < auction.winning_bid.value + 10)

    errors.add(:value, "needs to be greater than #{auction.winning_bid.value + 10} to cover the currently winning bid")
  end

  def enough_balance
    return unless user.balance <= value

    errors.add(:value, 'is bigger than your current balance')
  end
end
