FactoryGirl.define do
  factory :event do
    chapter
    name { Faker::Lorem.sentence }
    starts_at 3.days.from_now
    ends_at 3.days.from_now + 3.hours
    published true
    announced false
    capacity 10
    email_info { Faker::Lorem.paragraph }
    venue_name { Faker::Company.name }
    venue_postcode { Faker::Address.postcode }
    venue_info { Faker::Lorem.sentence }

    factory :unpublished_event do
      published false
    end

    factory :announced_event do
      announced true
    end

    factory :full_event do
      after(:create) do |event|
        event.capacity.times { FactoryGirl.create(:accepted_invitation, event: event) }
      end
    end
  end
end
