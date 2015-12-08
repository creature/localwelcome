FactoryGirl.define do
  factory :admin_role, class: Role do
    user
    chapter nil
    role Role.roles["admin"]
  end

  factory :chapter_role, class: Role do
    user
    chapter
    role Role.roles["chapter_organiser"]
  end
end
