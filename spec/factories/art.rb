FactoryBot.define do
  factory :art do
    description { Faker::Lorem.sentence(word_count: rand(3..10)) }
    title { "#{Faker::Color.color_name.capitalize} #{Faker::Ancient.hero}" }
    author { Faker::FunnyName.name }
    year { rand(1900..Date.today.year).to_s }
    creator { create(:user) }
    owner { creator }
    trait :owner_is_not_creator do
      owner { create(:user) }
      creator { create(:user) }
    end
  end
end
