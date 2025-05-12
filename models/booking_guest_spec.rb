require 'rails_helper'

RSpec.describe BookingGuest, type: :model do
  describe "Associations" do
    it { should belong_to(:booking) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:booking_id) }
  end

  describe "File Attachment" do
    it { should have_one_attached(:id_proof) }
  end
end
