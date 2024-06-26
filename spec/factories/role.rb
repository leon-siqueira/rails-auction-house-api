# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    user { association(:user) }
    trait :admin do
      kind { 'admin' }
    end

    trait :artist do
      kind { 'artist' }
    end

    trait :auctioneer do
      kind { 'auctioneer' }
    end

    trait :buyer do
      kind { 'buyer' }
    end
  end
end
