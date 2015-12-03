FactoryGirl.define do
  factory :invitation do
    user
    event
    invited false
    attending false
    status nil
  end
end
