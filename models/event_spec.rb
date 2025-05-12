require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "Validations" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(100) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:description).is_at_most(1000) }
    it { should validate_presence_of(:start_datetime) }
    it { should validate_presence_of(:end_datetime) }
    it { should validate_presence_of(:base_ticket_price) }
    it { should validate_numericality_of(:base_ticket_price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:location_id) }
    it { should validate_presence_of(:category_id) }
    it { should validate_presence_of(:organizer_id) }
    it { should validate_presence_of(:capacity) }
    it { should validate_numericality_of(:capacity).only_integer.is_greater_than(0) }
  end

  describe "Associations" do
    it { should belong_to(:location) }
    it { should belong_to(:category) }
    it { should belong_to(:organizer).class_name("User").with_foreign_key("organizer_id") }
    it { should have_many(:event_discounts).dependent(:destroy) }
    it { should have_many(:bookings).dependent(:destroy) }
  end
end
