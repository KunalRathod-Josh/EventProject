FactoryBot.define do
  factory :booking do
    user { association(:user) }
    event { association(:event) }
    quantity { 5 }
    total_price { event.base_ticket_price * quantity  }
    status { "confirm" }
    discount_applied { "EarlyBird" }
  end
end
