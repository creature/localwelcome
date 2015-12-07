require 'rails_helper'

describe InvitationsController do
  let(:invite) { FactoryGirl.create(:invitation) }
  let(:sent_invite) { FactoryGirl.create(:sent_invitation) }
  let(:accepted_invite) { FactoryGirl.create(:accepted_invitation) }

  context "Accepting invites" do
    it "Lets a user accept an invitation that's been sent" do
      expect(sent_invite.sent?).to be true
      get :accept, token: sent_invite.id

      sent_invite.reload
      expect(sent_invite.accepted?).to be true
    end

    it "Doesn't allow an invitation to be accepted that hasn't been sent" do
      get :accept, token: invite.id

      invite.reload
      expect(invite.accepted?).to be false
    end
  end

  context "Declining invites" do
    it "Lets a user decline a sent invitation" do
      get :decline, token: sent_invite.id

      sent_invite.reload
      expect(sent_invite.declined?).to be true
    end

    it "Doesn't allow a user to decline an unsent invitation" do
      get :decline, token: invite.id

      invite.reload
      expect(invite.declined?).to be false
    end

    it "Allows a user to decline a previously-accepted invitation" do
      get :decline, token: accepted_invite.id

      accepted_invite.reload
      expect(accepted_invite.accepted?).to be false
      expect(accepted_invite.declined?).to be true
    end
  end
end
