FactoryGirl.define do
  factory :chapter do
    name { Faker::Address.city }
    description { Faker::Lorem.paragraph }
  end

end
