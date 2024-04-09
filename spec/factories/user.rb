# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'pass1234' }
    balance { 1000 }
    token_expiration { nil }
  end
end
