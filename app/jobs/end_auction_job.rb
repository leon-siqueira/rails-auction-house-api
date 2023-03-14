class EndAuctionJob < ApplicationJob
  queue_as :default

  def perform(auction)
    auction.update(status: :finished)
    # TODO: assign winner and change owner if there is a winner
  end
end
