FactoryGirl.define do
  factory :event do
    chapter
    title Faker::Lorem.sentence
    starts_at 72.hours.from_now
    ends_at 75.hours.from_now
  end

end
