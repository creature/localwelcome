FactoryGirl.define do
  factory :invitation do
    user
    event
    invited nil
    attending nil
    status nil

    factory :sent_invitation do
      invited true
    end

    factory :accepted_invitation do
      invited true
      attending true
    end
  end
end
