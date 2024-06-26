# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    amount { 1 }

    trait :deposit do
      receiver { association(:user) }
      kind { 'deposit' }
    end

    trait :withdrawal do
      giver { association(:user) }
      kind { 'withdrawal' }
    end

    trait :bid do
      giver { association(:user) }
      receiver { association(:auction) }
      kind { 'bid' }
      amount { 200 }
    end

    trait :auction_income do
      giver { association(:auction) }
      receiver { association(:user) }
      kind { 'auction_income' }
      amount { 200 }
    end

    trait :covered_bid do
      giver { association(:auction) }
      receiver { association(:user) }
      kind { 'covered_bid' }
      amount { 200 }
    end
  end
end
