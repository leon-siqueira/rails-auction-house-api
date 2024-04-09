# frozen_string_literal: true

class EndAuctionJob < ApplicationJob
  queue_as :default

  def perform(auction)
    auction.update(status: :finished)
    return unless auction.bids.any?

    winner_bid ||= auction.winning_bid
    auction.art.update(owner: winner_bid.giver)
    Transaction.create(kind: :auction_income, giver: auction, amount: winner_bid.amount, receiver: auction.user)
  end
end
