class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :subscriptions
  has_many :chapters, through: :subscriptions
  has_many :roles

  # Is this user subscribed to a given chapter?
  def subscribed_to?(chapter)
    subscriptions.where(chapter: chapter).exists?
  end

  # Is this user an admin?
  def admin?
    roles.admin.exists?
  end
end
