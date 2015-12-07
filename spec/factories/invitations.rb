FactoryGirl.define do
  factory :invitation do
    user
    event

    factory :accepted_invitation do
      before(:build) { |invite| invite.aasm_state = :accepted }
      after(:create) do |invite|
        invite.aasm_state = :accepted
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
