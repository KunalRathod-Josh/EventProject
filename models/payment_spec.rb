require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe "Associations" do
    it { should belong_to(:booking) }
  end

  describe "Validations" do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_presence_of(:payment_method) }
  end
end
