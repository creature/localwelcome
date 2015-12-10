require 'rails_helper'

describe Event do
  describe "Validations" do
    let(:event) { FactoryGirl.create(:event) }

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
end
