class UserMailer < ApplicationMailer
  def invite(invitation)
    @user = invitation.user
    @event = invitation.event.decorate
    @token = invitation.token

    mail to: @user.email, subject: "An invitation to #{@event.name}"
  end

  def more_info_required(invitation)
    @user = invitation.user
    @event = invitation.event

    mail to: @user.email, subject: "We need more details before you can attend #{@event.name}"
  end
end
