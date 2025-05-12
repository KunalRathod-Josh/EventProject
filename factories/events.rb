FactoryBot.define do
  factory :event do
    start_datetime { "2023-10-01 10:00:00" }
    end_datetime { "2023-10-01 12:00:00" }
    title { "Sample Event" }
    description { "This is a sample event description." }
    location { association(:location) }
    category { association(:category) }
    organizer { association(:user, :organizer) }
    base_ticket_price { 1000 }
    is_early_bird_active { false }
    is_amount_discount_active { false }
    capacity { 100 }
    registered_count { 20 }
  end
end
