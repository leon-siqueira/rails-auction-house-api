FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'pass1234' }
    balance { 1000 }
  end
end
