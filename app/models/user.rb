# A user record - someone who can log in to the system.
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :subscriptions
  has_many :chapters, through: :subscriptions
  has_many :roles
  has_many :invitations
  has_many :events, through: :invitations

  validates :email, presence: true

  # Is this user subscribed to a given chapter?
  def subscribed_to?(chapter)
    subscriptions.where(chapter: chapter).exists?
  end

  # Is this user an admin?
  def admin?
    roles.admin.exists?
  end

  def profile_completion_score
    attrs = [:name, :bio, :telephone]
    (attrs.reject { |attr| self.send(attr).blank? }.count.to_f / attrs.count) * 100
  end
end
