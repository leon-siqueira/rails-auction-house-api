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
  # TODO: validate if the current balance of the user is enough for the bid

  def auction_in_progress
    return unless Time.zone.now > auction.end_date

    errors.add(:created_at, 'Bids can only be placed on currently in progress auctions')
  end

  def minimal_bid_reached
    return unless auction.bids.empty? && (value < auction.minimal_bid)

    errors.add(:value, "needs to be greater than #{auction.minimal_bid - 1}")
  end

  def winning_bid_covered
    return unless auction.bids.any? && (value < auction.winning_bid.value + 10)

    errors.add(:value, "needs to be greater than #{auction.winning_bid.value + 10}")
  end
end
