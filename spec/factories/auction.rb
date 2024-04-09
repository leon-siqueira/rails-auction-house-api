# frozen_string_literal: true

FactoryBot.define do
  factory :auction do
    art { association(:art) }
    user { art.owner }
    description { Faker::Lorem.sentence(word_count: rand(3..10)) }
    minimal_bid { 200 }
    start_date { Time.zone.now }
    end_date { 1.hour.from_now }
    status { 'in_progress' }
  end
end
