require 'rails_helper'

describe Event do
  let(:event) { FactoryGirl.create(:event) }

  describe "Validations" do
    it "Must have a start time" do
      expect(event).to be_valid
      event.starts_at = nil
      expect(event).not_to be_valid
    end

    it "Must have an end time" do
      expect(event).to be_valid
      event.ends_at = nil
      expect(event).not_to be_valid
    end

    it "Must end after it starts" do
      event.starts_at = 2.hours.ago
      event.ends_at = 3.hours.ago
      expect(event).not_to be_valid

      event.ends_at = event.starts_at
      expect(event).not_to be_valid
    end

    it "Must have a capacity greater than 0" do
      event.capacity = 5
      expect(event).to be_valid
      event.capacity = 1
      expect(event).to be_valid
      event.capacity = 0
      expect(event).not_to be_valid
      event.capacity = -1
      expect(event).not_to be_valid
    end
  end

  it "Is full when the number of accepted invites is equal to its stated capacity" do
    event.update_attributes(capacity: 3)
    expect(event).not_to be_full

    # Unaccepted invites don't count towards capacity
    4.times do
      FactoryGirl.create(:invitation, event: event)
      expect(event).not_to be_full
    end

    # Fewer than `capacity` attendees don't set it as full
    2.times do
      FactoryGirl.create(:accepted_invitation, event: event)
      expect(event).not_to be_full
    end

    FactoryGirl.create(:accepted_invitation, event: event)
    expect(event).to be_full
  end
end
