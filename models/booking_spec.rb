require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:event) }
    it { should have_many(:booking_guests).dependent(:destroy) }
    it { should have_one(:payment) }
  end

  describe "Validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:event_id) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:total_price) }
    it { should validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:total_price).is_greater_than_or_equal_to(0) }
  end
end
