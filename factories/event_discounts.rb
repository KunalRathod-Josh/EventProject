FactoryBot.define do
  factory :event_discount do
    trait :EarlyBird do
      name { "Early Bird Discount" }
      discount_type { "EarlyBird" }
      valid_until { Date.today + 30.days }
      discount_value { 10.0 }
      is_active { true }
    end

    trait :AmountDiscount do
      name { "Amount Discount" }
      discount_type { "AmountDiscount" }
      min_total_amount { 5000.0 }
      discount_value { 5.0 }
      is_active { true }
    end
  end
end
