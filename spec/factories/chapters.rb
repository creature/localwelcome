FactoryGirl.define do
  factory :chapter do
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
  end

end
