require 'rails_helper'
require 'cancan/matchers'

describe Ability do
  let(:user) { FactoryGirl.create(:user) }
  let(:organiser) { FactoryGirl.create(:chapter_organiser) }
  let(:admin) { FactoryGirl.create(:admin) }

  describe "Regular users" do
    let(:ability) { Ability.new(user) }

    it "Should be able to view events" do
      expect(ability).to be_able_to(:read, Event)
    end

    it "Should be able to view chapters" do
      expect(ability).to be_able_to :read, Chapter
    end

    it "Should not be able to edit events" do
      expect(ability).not_to be_able_to :update, Event
    end

    it "Should not be able to edit chapters" do
      expect(ability).not_to be_able_to :update, Chapter
    end

    it "Should not be able to create events" do
      expect(ability).not_to be_able_to :create, Event
    end

    it "Should not be able to create chapters" do
      expect(ability).not_to be_able_to :create, Chapter
    end
  end

  describe "Chapter organisers" do
    let(:ability) { Ability.new(organiser) }
    let(:chapter) { organiser.organised_chapters.first }
    let(:event) { FactoryGirl.create(:event, chapter: chapter) }

    it "Should be able to manage their chapters" do
      expect(ability).to be_able_to :read, chapter
      expect(ability).to be_able_to :update, chapter
    end

    it "Should be able to manage their events" do
      expect(ability).to be_able_to :manage, event
    end

    it "Should not be able to manage other chapters" do
      chapter = FactoryGirl.create(:chapter)
      expect(ability).not_to be_able_to :manage, chapter
    end

    it "Should not be able to manage other events" do
      other_event = FactoryGirl.create(:event)
      expect(ability).not_to be_able_to :manage, other_event
    end

    it "Should be able to create new events" do
      new_event = FactoryGirl.build(:event, chapter: chapter)
      expect(ability).to be_able_to :create, new_event
    end

    it "Should not be able to create new chapters" do
      expect(ability).not_to be_able_to :create, Chapter
    end
 end

  describe "Administrators" do
    let(:ability) { Ability.new(admin) }

    it "Should be able to create new chapters" do
      expect(ability).to be_able_to :create, Chapter
    end

    it "Should be able to manage chapters" do
      expect(ability).to be_able_to :manage, Chapter
    end

    it "Should be able to manage events" do
      expect(ability).to be_able_to :manage, Event
    end
  end
end
