class UserMailer < ApplicationMailer
  def invite(invitation)
    @user = invitation.user
    @event = invitation.event
    @token = invitation.id

    mail to: @user.email, subject: "An invitation to #{@event.title}"
  end
end
