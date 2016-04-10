FactoryGirl.define do
  factory :event do
    chapter
    name { Faker::Lorem.sentence }
    starts_at 3.days.from_now
    ends_at 3.days.from_now + 3.hours
    published true
    announced false
    capacity 10
    description { Faker::Lorem.paragraph }
    email_info { Faker::Lorem.paragraph }
    venue_name { Faker::Company.name }
    venue_postcode { Faker::Address.postcode }
    venue_info { Faker::Lorem.sentence }

    trait :unpublished do
      published false
    end

    trait :announced do
      announced true
    end

    factory :full_event do
      after(:create) do |event|
        event.capacity.times { FactoryGirl.create(:accepted_invitation, event: event) }
      end
    end
  end
end
