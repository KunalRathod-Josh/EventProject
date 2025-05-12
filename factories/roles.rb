FactoryBot.define do
  factory :role do
    name { "Attendee" }

    trait :admin do
      name { "Admin" }
    end

    trait :organizer do
      name { "Organizer" }
    end

    initialize_with { Role.find_or_create_by(name: name) }
  end
end
