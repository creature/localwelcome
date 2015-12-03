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
end
