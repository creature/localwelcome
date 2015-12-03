FactoryGirl.define do
  factory :event do
    chapter
    title { Faker::Lorem.sentence }
    starts_at 3.days.from_now
    ends_at 3.days.from_now + 3.hours
  end
end
