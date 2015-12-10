class EventMailerPreview < ActionMailer::Preview
  def announcement
    EventMailer.announcement(User.first, Event.first)
  end
end
