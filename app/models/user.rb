class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :subscriptions
  has_many :chapters, through: :subscriptions

  # Is this user subscribed to a given chapter?
  def subscribed_to?(chapter)
    subscriptions.where(chapter: chapter).exists?
  end
end
