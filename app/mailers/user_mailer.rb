class UserMailer < ApplicationMailer
  def invite(invitation)
    @user = invitation.user
    @event = invitation.event.decorate
    @token = invitation.token

    mail to: @user.email, subject: "An invitation to #{@event.name}"
  end
end
