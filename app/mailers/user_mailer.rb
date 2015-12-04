class UserMailer < ApplicationMailer
  def invite(invitation)
    @user = invitation.user
    @event = invitation.event

    mail to: @user.email, subject: "An invitation to #{@event.title}"
  end
end
