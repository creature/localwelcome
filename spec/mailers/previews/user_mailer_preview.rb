class UserMailerPreview < ActionMailer::Preview
  def invite
    invitation = FactoryGirl.create(:invitation)
    UserMailer.invite(invitation)
  end
end
