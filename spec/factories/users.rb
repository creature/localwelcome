FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.safe_email }
    password { Faker::Lorem.characters(10) }
    telephone { Faker::PhoneNumber.phone_number }
    bio { Faker::Lorem.paragraph }

    factory :empty_user do
      name nil
      telephone nil
      bio nil
    end
  end
end
