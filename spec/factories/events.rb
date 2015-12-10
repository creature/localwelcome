FactoryGirl.define do
  factory :event do
    chapter
    title { Faker::Lorem.sentence }
    starts_at 3.days.from_now
    ends_at 3.days.from_now + 3.hours
    published true
    capacity 10

    factory :unpublished_event do
      published false
    end
  end
end
