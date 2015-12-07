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
      expect(sent_invite).to be_accepted
    end

    it "Doesn't allow an invitation to be accepted that hasn't been sent" do
      get :accept, token: invite.id

      invite.reload
      expect(invite).not_to be_accepted
    end
  end

  context "Declining invites" do
    it "Lets a user decline a sent invitation" do
      get :decline, token: sent_invite.id

      sent_invite.reload
      expect(sent_invite).to be_declined
    end

    it "Doesn't allow a user to decline an unsent invitation" do
      get :decline, token: invite.id

      invite.reload
      expect(invite).not_to be_declined
    end

    it "Allows a user to decline a previously-accepted invitation" do
      get :decline, token: accepted_invite.id

      accepted_invite.reload
      expect(accepted_invite).not_to be_accepted
      expect(accepted_invite).to be_declined
    end
  end
end
