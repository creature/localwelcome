require 'rails_helper'

feature "Managing events" do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:event) { FactoryGirl.create(:event) }
  let(:unpublished_event) { FactoryGirl.create(:unpublished_event) }
  let(:announced_event) { FactoryGirl.create(:announced_event) }

  before { login(admin) }

  context "Announcing events" do
    scenario "You cannot announce an unpublished event" do
      visit admin_chapter_event_path(unpublished_event.chapter, unpublished_event)
      expect(page).not_to have_link "Send announcement emails"
    end

    scenario "A published event can be announced" do
      visit admin_chapter_event_path(event.chapter, event)
      expect(page).to have_link "Send announcement emails"
    end

    scenario "Announcing an event sends emails to that chapter's users" do
      other_chapter = FactoryGirl.create(:chapter)
      chapter_users = FactoryGirl.create_list(:chapter_user, 3, chapter: event.chapter)
      other_users = FactoryGirl.create_list(:chapter_user, 3, chapter: other_chapter)
      emails = ActionMailer::Base.deliveries

      visit admin_chapter_event_path(event.chapter, event)
      expect { click_link "Send announcement emails" }.to change { emails.count }.by chapter_users.count
      recipients = emails.map { |m| m.to.first }

      # All these chapter users should have received an email
      chapter_users.each { |cu| expect(recipients).to include cu.email }

      # None of the other users should have received an email
      other_users.each { |ou| expect(recipients).not_to include ou.email }
    end

    scenario "The interface lets an admin know that an event has been announced" do
      visit admin_chapter_event_path(announced_event.chapter, announced_event)
      expect(page).to have_content "Announcement emails sent"
    end

    scenario "You can't announce an event more than once" do
      expect(event).not_to be_announced
      visit admin_chapter_event_path(event.chapter, event)
      click_link "Send announcement emails"

      event.reload
      expect(event).to be_announced
      expect(page).not_to have_link "Send announcement emails"
    end
  end
end
