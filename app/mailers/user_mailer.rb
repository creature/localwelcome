class UserMailer < ApplicationMailer
  def invite(user, event)
    @user = user
    @event = event

    mail to: user.email, subject: "An invitation to #{@event.title}"
  end
end
