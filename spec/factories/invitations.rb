FactoryGirl.define do
  factory :invitation do
    user
    event
    who_do_you_want_to_meet { Faker::Lorem.sentence }

    factory :accepted_invitation do
      before(:build) { |invite| invite.aasm_state = :accepted }
      after(:create) do |invite|
        invite.aasm_state = :accepted
        invite.save
      end
    end

    factory :declined_invitation do
      before(:build) { |invite| invite.aasm_state = :declined }
      after(:create) do |invite|
        invite.aasm_state = :declined
        invite.save
      end
    end

    factory :sent_invitation do
      before(:build) { |invite| invite.aasm_state = :sent }
      after(:create) do |invite|
        invite.aasm_state = :sent
        invite.save
      end
    end
  end
end
