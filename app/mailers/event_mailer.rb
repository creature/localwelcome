class EventMailer < ApplicationMailer
  add_template_helper(DatesHelper)

  # Send an announcement about an event to a user.
  def announcement(user, event)
    @user = user
    @event = event
    mail to: user.email, subject: "Local Welcome #{event.chapter.name} - our upcoming event '#{event.name}'"
  end

  # Send a user a reminder about an event to a user.
  def first_reminder(user, invite)
    reminder_helper(user, invite, "First reminder about Local Welcome #{invite.event.chapter.name}'s #{invite.event.name}")
  end

  def last_reminder(user, invite)
    reminder_helper(user, invite, "Final reminder about Local Welcome #{invite.event.chapter.name}'s #{invite.event.name}")
  end

  protected

  def reminder_helper(user, invite, subject)
    @user = user
    @invite = invite
    @event = invite.event
    mail to: user.email, subject: subject, template_name: "reminder"
  end
end
