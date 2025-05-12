require 'rails_helper'

RSpec.describe Role, type: :model do
  describe "Set Roles" do
    it "has a default role" do
      role = create(:role)
      expect(role.name).to eq("Attendee")
    end

    it "has an admin role" do
      role = create(:role, :admin)
      expect(role.name).to eq("Admin")
    end

    it "has an organizer role" do
      role = create(:role, :organizer)
      expect(role.name).to eq("Organizer")
    end
  end

  describe "Associations" do
    it "has many users" do
      role = create(:role)
      user1 = create(:user, role: role)
      user2 = create(:user, role: role)
      expect(role.users).to include(user1, user2)
    end
  end

  describe "Validations" do
    it "validates presence of name" do
      role = build(:role, name: nil)
      expect(role).not_to be_valid
      expect(role.errors[:name]).to include("can't be blank")
    end
  end
end
