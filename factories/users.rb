FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "sample1234" }

    association :role

    trait :admin do
      role { association(:role, :admin) }
    end

    trait :organizer do
      role { association(:role, :organizer) }
      organisation_name { Faker::Company.name }
      bio { Faker::Lorem.paragraph }
    end
  end
end
