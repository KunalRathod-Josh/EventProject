require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    it "shorter password is invalid" do
      user = build(:user, password: "short")
      expect(user).not_to be_valid
    end

    it "email should match regex" do
      user = build(:user, email: "invalid_email")
      expect(user).not_to be_valid
    end

    it "email should be unique" do
      user1 = create(:user)
      user2 = build(:user, email: user1.email)
      expect(user2).not_to be_valid
      expect(user2.errors[:email]).to include("has already been taken")
    end

    it "organisation name is required for organizer" do
      user = build(:user, :organizer, organisation_name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:organisation_name]).to include("can't be blank")
    end

    it "bio is required for organizer" do
      user = build(:user, :organizer, bio: nil)
      expect(user).not_to be_valid
      expect(user.errors[:bio]).to include("can't be blank")
    end
  end

  describe "Associations" do
    it "has many events" do
      user = create(:user, :organizer)
      event1 = create(:event, organizer: user)
      event2 = create(:event, organizer: user)
      expect(user.events).to include(event1, event2)
    end
  end
end
