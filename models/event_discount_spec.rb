require 'rails_helper'

RSpec.describe EventDiscount, type: :model do
  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:discount_type) }
    it { should validate_inclusion_of(:discount_type).in_array(EventDiscount::DISCOUNT_TYPES) }
    it { should validate_presence_of(:discount_value) }
    it { should validate_numericality_of(:discount_value).is_greater_than(0) }
  end

  describe "Associations" do
    it { should belong_to(:event) }
  end
end
