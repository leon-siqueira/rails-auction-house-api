# frozen_string_literal: true

class StartAuctionJob < ApplicationJob
  queue_as :default

  def perform(auction)
    auction.update(status: :in_progress)
    EndAuctionJob.set(wait_until: auction.end_date).perform_later(auction)
  end
end
