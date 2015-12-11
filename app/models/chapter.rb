class Chapter < ActiveRecord::Base
  has_many :events
  has_many :subscriptions
  has_many :users, through: :subscriptions
  has_many :roles
  has_many :organisers, through: :roles, source: :user

  validates :name, uniqueness: true, presence: true

  # Attempts to retrieve a user associated with this chapter, either as a subscriber or as an organiser.
  def find_user(id)
    users.find(id)
  rescue ActiveRecord::RecordNotFound
    organisers.find(id)
  end

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
