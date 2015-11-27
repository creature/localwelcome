class Chapter < ActiveRecord::Base
  has_many :events

  validates :name, uniqueness: true, presence: true

  def upcoming_events
    events.chronological.where("starts_at > ?", DateTime.now)
  end

  def published_upcoming_events
    upcoming_events.published
  end

  def past_events
    events.archaeological.where("starts_at < ?", DateTime.now)
  end

  def published_past_events
    past_events.published
  end

  def next_event
    published_upcoming_events.first
  end
end
