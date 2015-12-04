require 'rails_helper'

feature "The admin panel" do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:chapter) { FactoryGirl.create(:chapter) }
  let(:event) { FactoryGirl.create(:event) }

  let(:event_title) { Faker::Lorem.words(4).join(" ") }
  let(:event_description) { Faker::Lorem.paragraph }
  let(:event_starts_at) { 1.week.from_now.beginning_of_hour }
  let(:event_ends_at) { (1.week.from_now + 2.hours).beginning_of_hour }

  before { login(admin) }

  context "Events" do
    it "Allows an admin to create an event" do
      visit admin_chapter_path(chapter)
      fill_in_event_form(event_title, event_description, event_starts_at, event_ends_at)

      expect { click_button "Create new event" }.to change { Event.count }.by 1
      expect(page).to have_content event_title
      expect(page).to have_content event_description

      new_event = Event.last
      expect(new_event.starts_at).to eq event_starts_at
      expect(new_event.ends_at).to eq event_ends_at
    end

    it "Creates unpublished events by default" do
      visit admin_chapter_path(chapter)
      fill_in_event_form(event_title, event_description, event_starts_at, event_ends_at)
      click_button "Create new event"

      expect(Event.last.published?).to be false
    end

    it "Allows an admin to publish an unpublished event" do
      event = FactoryGirl.create(:unpublished_event)
      visit admin_chapter_event_path(event.chapter, event)
      click_button "Publish"
      event.reload
      expect(event.published?).to be true
    end

    it "Allows an admin to unpublish a published event" do
      visit admin_chapter_event_path(event.chapter, event)
      click_button "Unpublish"
      event.reload
      expect(event.published?).to be false
    end

    it "Allows an admin to edit an event" do
      new_title = Faker::Lorem.sentence
      new_start_time = (event.starts_at - 1.hour).beginning_of_hour

      visit edit_admin_chapter_event_path(event.chapter, event)
      fill_in :event_title, with: new_title
      datetime_select :event_starts_at, new_start_time
      click_button "Save changes"

      # Flash message should be a success, not an error
      expect(page).not_to have_selector ".alert-danger"
      expect(page).to have_selector ".alert-info"

      # Event should have been updated
      event.reload
      expect(event.title).to eq new_title
      expect(event.starts_at).to eq new_start_time
    end

    it "Allows an admin to see potential attendees" do
      invitations = FactoryGirl.create_list(:invitation, 3, event: event)
      other_invitations = FactoryGirl.create_list(:invitation, 3)

      visit admin_chapter_event_path(event.chapter, event)
      invitations.each { |invite| expect(page).to have_content invite.user.email }
      other_invitations.each { |invite| expect(page).not_to have_content invite.user.email }
    end

    it "Allows an admin to send an attendee an invite" do
      invitation = FactoryGirl.create(:invitation, event: event)
      emails = ActionMailer::Base.deliveries

      visit admin_chapter_event_path(event.chapter, event)
      expect { click_button "Send invitation" }.to change { emails.count }.by 1
      expect(emails.last.to.last).to eq invitation.user.email

      invitation.reload
      expect(invitation.invited?).to be true
    end
  end
end

def fill_in_event_form(title, description, starts_at, ends_at)
  fill_in :event_title, with: title
  fill_in :event_description, with: description
  datetime_select(:event_starts_at, starts_at)
  datetime_select(:event_ends_at, ends_at)
end

