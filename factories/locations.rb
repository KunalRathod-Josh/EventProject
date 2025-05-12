FactoryBot.define do
  factory :location do
    name { "Sample Location" }
    address { "123 Sample St, Sample City, SC 12345" }
    city { "Sample City" }
    pin_code { "12345" }
  end
end
