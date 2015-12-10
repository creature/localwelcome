class EventMailerPreview < ActionMailer::Preview
  def announcement
    EventMailer.announcement(User.first, Event.first)
  end

  def first_reminder
    EventMailer.first_reminder(User.first, Invitation.first)
  end

  def last_reminder
    EventMailer.last_reminder(User.first, Invitation.first)
  end
end
