# Allows a user to be a "member" of a local chapter. If they're a member, they'll get emails about the upcoming events.
class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :chapter

  validates :user_id, uniqueness: { scope: :chapter_id }
end
