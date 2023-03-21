FactoryBot.define do
  factory :auction do
    art { create(:art) }
    user { art.owner }
    description { Faker::Lorem.sentence(word_count: rand(3..10)) }
    minimal_bid { 200 }
    start_date { Time.zone.now }
    end_date { Time.zone.now + 1.hour }
    status { 'in_progress' }
  end
end
