# frozen_string_literal: true

FactoryBot.define do
  factory :bid do
    auction { create(:auction) }
    user { create(:user) }
    value { auction.minimal_bid }
  end
end
