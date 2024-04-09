# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    amount { 1 }

    trait :deposit do
      receiver { build(:user) }
      kind { 'deposit' }
    end

    trait :withdrawal do
      giver { build(:user) }
      kind { 'withdrawal' }
    end

    trait :bid do
      giver { build(:user) }
      receiver { build(:auction) }
      kind { 'bid' }
      amount { 200 }
    end

    trait :auction_income do
      giver { build(:auction) }
      receiver { build(:user) }
      kind { 'auction_income' }
      amount { 200 }
    end

    trait :covered_bid do
      giver { build(:auction) }
      receiver { build(:user) }
      kind { 'covered_bid' }
      amount { 200 }
    end
  end
end
