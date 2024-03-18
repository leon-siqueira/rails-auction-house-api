class EndAuctionJob < ApplicationJob
  queue_as :default

  def perform(auction)
    auction.update(status: :finished)
    auction_owner ||= auction.user
    winner_bid ||= auction.winning_bid
    return unless auction.bids.any?

    auction.art.update(owner: winner_bid.user)
    Transaction.create(kind: :auction_income, giver: auction, value: winner_bid.value, receiver: auction_owner)
    auction_owner.update_balance
  end
end
