class UserMailerPreview < ActionMailer::Preview
  def invite
    UserMailer.invite(Invitation.first)
  end
end
