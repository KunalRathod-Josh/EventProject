require 'rails_helper'

RSpec.describe Location, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:pin_code) }
  end

  it "is invalid if pin_code is not 5 or 6 digits" do
      invalid_location = build(:location, pin_code: "1234")
      expect(invalid_location).not_to be_valid
      expect(invalid_location.errors[:pin_code]).to include("should be 5 or 6 digits")
  end



  describe "associations" do
    it { should have_many(:events) }
  end
end
