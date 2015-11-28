class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :chapter

  validates :user_id, uniqueness: { scope: :chapter_id }
end
