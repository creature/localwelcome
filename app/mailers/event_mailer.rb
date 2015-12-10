class EventMailer < ApplicationMailer
  add_template_helper(DatesHelper)

  # Send an announcement about an event to a user.
  def announcement(user, event)
    @user = user
    @event = event
    mail to: user.email, subject: "Local Welcome #{event.chapter.name} - our upcoming event '#{event.title}'"
  end
end
