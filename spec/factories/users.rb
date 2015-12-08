FactoryGirl.define do
  factory :user do
    transient { chapter nil }

    name { Faker::Name.name }
    email { Faker::Internet.safe_email }
    password { Faker::Lorem.characters(10) }
    telephone { Faker::PhoneNumber.phone_number }
    bio { Faker::Lorem.paragraph }
    postcode { Faker::Address.postcode }
    life_skills { Faker::Lorem.paragraph }
    language_skills { Faker::Lorem.paragraph }

    factory :empty_user do
      name nil
      telephone nil
      bio nil
      postcode nil
      life_skills nil
      language_skills nil
    end

    factory :admin do
      after(:create) { |user| FactoryGirl.create(:admin_role, user: user) }
    end

    factory :chapter_organiser do
      after(:create) do |user, evaluator|
        if evaluator.chapter
          FactoryGirl.create(:chapter_role, user: user, chapter: evaluator.chapter)
        else
          FactoryGirl.create(:chapter_role, user: user)
        end
      end
    end
  end
end
