require 'rails_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  let(:empty_user) { FactoryGirl.create(:empty_user) }

  it "Gives an empty profile a score of 0" do
    expect(empty_user.profile_completion_score).to eq 0
  end

  it "Gives a completed profile a score of 100" do
    expect(user.profile_completion_score).to eq 100
  end

  it "Gives a semi-complete profile an appropriate score" do
    user.bio = nil
    expect(user.profile_completion_score).to be_within(0.01).of 66.66
  end

  describe "Validations" do
    it "Requires a valid email" do
      expect(user).to be_valid

      user.email = nil
      expect(user).not_to be_valid

      user.email = Faker::Lorem.sentence
      expect(user).not_to be_valid

      user.email = "bob@"
      expect(user).not_to be_valid

      user.email = "bob..example@gmail.com"
      expect(user).not_to be_valid

      user.email = "bob.example@gmail..com"
      expect(user).not_to be_valid
    end

    it "Does not allow two users to have the same address" do
      new_user = FactoryGirl.build(:user, email: user.email)
      expect(new_user).not_to be_valid
    end
  end
end
