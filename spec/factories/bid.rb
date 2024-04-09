# frozen_string_literal: true

FactoryBot.define do
  factory :bid do
    auction { association(:auction) }
    user { association(:user) }
    value { auction.minimal_bid }
  end
end
