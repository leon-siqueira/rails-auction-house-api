class StartAuctionJob < ApplicationJob
  queue_as :default

  def perform(auction)
    auction.update(status: :in_progress)
  end
end
