FactoryGirl.define do
  factory :chapter do
    name { Faker::Address.city }
    description { Faker::Lorem.paragraph }

    factory :chapter_without_description do
      description nil
    end
  end

end
