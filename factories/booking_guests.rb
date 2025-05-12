FactoryBot.define do
  factory :booking_guest do
    sequence(:name) { |n| "Guest #{n}" }
    age { rand(18..70) }
    association :booking

    trait :adult do
      age { rand(18..65) }
    end

    trait :senior do
      age { rand(66..80) }
    end

    trait :child do
      age { rand(0..17) }
    end
  end
end
