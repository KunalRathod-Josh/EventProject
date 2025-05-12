FactoryBot.define do
  factory :payment do
    association :user
    association :booking
    amount { 2000 }
    payment_method { "credit_card" }
    status { "completed" }
    transaction_id { SecureRandom.hex(10) }

    trait :pending do
      status { "pending" }
    end

    trait :failed do
      status { "failed" }
    end

    trait :refunded do
      status { "refunded" }
      amount { 0 }
    end
  end
end
