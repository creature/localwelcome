# A user record - someone who can log in to the system.
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :subscriptions
  has_many :chapters, through: :subscriptions
  has_many :roles
  has_many :invitations
  has_many :events, through: :invitations

  validates :email, presence: true, format: { without: /\.{2,}/ }

  # Is this user subscribed to a given chapter?
  def subscribed_to?(chapter)
    subscriptions.where(chapter: chapter).exists?
  end

  # Is this user an admin?
  def admin?
    roles.admin.exists?
  end

  # Does this user organise _any_ chapter?
  def organiser?
    roles.chapter_organiser.exists?
  end

  # Gets the chapters organised by this user.
  def organised_chapters
    Chapter.where(id: roles.chapter_organiser.pluck(:chapter_id)) # TODO: There's a better way to do this.
  end

  # A percentage score describing how complete a user's profile is.
  def profile_completion_score
    attrs = [:name, :bio, :telephone]
    (attrs.reject { |attr| self.send(attr).blank? }.count.to_f / attrs.count) * 100
  end
end
