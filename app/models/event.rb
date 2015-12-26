class Event < ActiveRecord::Base
  belongs_to :chapter
  has_many :invitations
  has_many :users, through: :invitations

  validates :chapter, presence: true
  validates :name, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }
  validate :starts_before_it_ends

  scope :chronological, -> { order({starts_at: :asc}) }
  scope :archaeological, -> { order({starts_at: :desc}) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }

  def in_the_past?
    ends_at < Time.zone.now
  end

  def full?
    invitations.accepted.count >= capacity
  end

  def attendees
    invitations.accepted.map(&:user)
  end

  def remaining_place_count
    n = capacity - attendees.count
    n >= 0 ? n : 0
  end

  def has_email_info?
    email_info.present?
  end

  def has_venue_info?
    venue_name.present? || venue_postcode.present? || venue_info.present?
  end

  protected

  def starts_before_it_ends
    if ends_at && starts_at && ends_at <= starts_at
      errors.add(:ends_at, "Event must end after the start time.")
    end
  end
end
