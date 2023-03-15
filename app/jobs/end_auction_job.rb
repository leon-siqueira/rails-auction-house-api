class EndAuctionJob < ApplicationJob
  queue_as :default

  def perform(auction)
    auction.update(status: :finished)
    auction_owner ||= auction.user
    winner_bid ||= auction.winning_bid
    return unless auction.bids.any?

    auction.art.update(owner: winner_bid.user)
    AuctionReturn.create(kind: :income, auction:, value: winner_bid.value, user: auction_owner)
    auction_owner.update_balance
  end
end
