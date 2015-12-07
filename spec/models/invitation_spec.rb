require 'rails_helper'

describe Invitation do
  let (:invite) { FactoryGirl.create(:invitation) }

  it "Allows an event to have more than one invitation" do
    second_invite = FactoryGirl.build(:invitation, event: invite.event)
    expect(second_invite).to be_valid
  end

  it "Limits a user to one invitation per event" do
    second_invite = FactoryGirl.build(:invitation, event: invite.event, user: invite.user)
    expect(second_invite).not_to be_valid
  end

  describe "Tokens" do
    it "Generates different tokens for different invites" do
      invites = FactoryGirl.create_list(:invitation, 3)
      tokens = invites.map(&:token)

      expect(tokens.uniq.length).to eq invites.length
    end

    it "Allows us to find invites by tokens" do
      token = invite.token

      found_invite = Invitation.find_by_token token
      expect(found_invite).to be_an Invitation
      expect(found_invite.id).to eq invite.id
    end

    it "Doesn't find invites for invalid tokens" do
      expect(Invitation.find_by_token "aslkjlkjlkj").not_to be
    end

    it "Doesn't find invites for previously-valid tokens" do
      token = invite.token
      invite.destroy

      expect { Invitation.find_by_token token }.to raise_error ActiveRecord::RecordNotFound
    end

  end
end
