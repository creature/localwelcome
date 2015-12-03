FactoryGirl.define do
  factory :admin_role, class: Role do
    user
    chapter nil
    role Role.roles["admin"]
  end
end
