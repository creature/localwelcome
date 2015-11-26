class Chapter < ActiveRecord::Base
  has_many :events

  validates :name, uniqueness: true, presence: true

  def upcoming_events
    events.chronological.where("starts_at > ?", DateTime.now)
  end

  def past_events
    events.archaeological.where("starts_at < ?", DateTime.now)
  end
end
