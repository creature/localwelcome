require 'rails_helper'

feature "The admin panel" do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:chapter) { FactoryGirl.create(:chapter) }
  let(:chapter_user) { FactoryGirl.create(:chapter_user, chapter: chapter) }
  let(:event) { FactoryGirl.create(:event) }
  let(:accepted_invite) { FactoryGirl.create(:accepted_invitation, event: event) }

  let(:event_name) { Faker::Lorem.words(4).join(" ") }
  let(:event_description) { Faker::Lorem.paragraph }
  let(:event_starts_at) { 1.week.from_now.beginning_of_hour }
  let(:event_ends_at) { (1.week.from_now + 2.hours).beginning_of_hour }

  before { login(admin) }

  context "Events" do
    it "Allows an admin to create an event" do
      visit admin_chapter_path(chapter)
      fill_in_event_form(event_name, event_description, event_starts_at, event_ends_at)

      expect { click_button "Create new event" }.to change { Event.count }.by 1
      expect(page).to have_content event_name
      expect(page).to have_content event_description

      new_event = Event.last
      expect(new_event.starts_at).to eq event_starts_at
      expect(new_event.ends_at).to eq event_ends_at
    end

    it "Creates unpublished events by default" do
      visit admin_chapter_path(chapter)
      fill_in_event_form(event_name, event_description, event_starts_at, event_ends_at)
      click_button "Create new event"

      expect(Event.last.published?).to be false
    end

    it "Allows an admin to publish an unpublished event" do
      event = FactoryGirl.create(:unpublished_event)
      visit admin_chapter_event_path(event.chapter, event)
      click_button "Publish"
      event.reload
      expect(event).to be_published
    end

    it "Allows an admin to unpublish a published event" do
      visit admin_chapter_event_path(event.chapter, event)
      click_button "Unpublish"
      event.reload
      expect(event.published?).to be false
    end

    it "Allows an admin to edit an event" do
      new_name = Faker::Lorem.sentence
      new_start_time = (event.starts_at - 1.hour).beginning_of_hour

      visit edit_admin_chapter_event_path(event.chapter, event)
      fill_in :event_name, with: new_name
      datetime_select :event_starts_at, new_start_time
      click_button "Save changes"

      # Flash message should be a success, not an error
      expect(page).not_to have_error_notice
      expect(page).to have_success_notice

      # Event should have been updated
      event.reload
      expect(event.name).to eq new_name
      expect(event.starts_at).to eq new_start_time
    end

    it "Allows an admin to see potential attendees" do
      invitations = FactoryGirl.create_list(:invitation, 3, event: event)
      other_invitations = FactoryGirl.create_list(:invitation, 3)

      visit admin_chapter_event_path(event.chapter, event)
      invitations.each { |invite| expect(page).to have_content invite.user.name }
      other_invitations.each { |invite| expect(page).not_to have_content invite.user.name }
    end

    it "Allows an admin to send an attendee an invite" do
      invitation = FactoryGirl.create(:invitation, event: event)
      emails = ActionMailer::Base.deliveries

      visit admin_chapter_event_path(event.chapter, event)
      expect { click_button "Send invitation" }.to change { emails.count }.by 1
      expect(emails.last.to.last).to eq invitation.user.email

      invitation.reload
      expect(invitation).to be_sent
    end

    it "Allows an admin to mark a user as attended" do
      expect(accepted_invite).to be_accepted

      visit admin_chapter_event_path(event.chapter, event)
      click_button "Mark as attended"

      accepted_invite.reload
      expect(accepted_invite).to be_attended
    end

    it "Allows an admin to mark a user as a no-show" do
      expect(accepted_invite).to be_accepted

      visit admin_chapter_event_path(event.chapter, event)
      click_button "Mark as no-show"

      accepted_invite.reload
      expect(accepted_invite).to be_no_show
    end
  end

  context "Users" do
    it "Allows an admin to view a user profile" do
      visit admin_chapter_user_path(chapter, chapter_user)

      expect(page).to have_content chapter_user.name
      expect(page).to have_content chapter_user.email
      expect(page).to have_content chapter_user.bio
    end

    it "Allows an admin to view all users associated with a chapter" do
      chapter_users = FactoryGirl.create_list(:chapter_user, 3, chapter: chapter)
      other_chapter = FactoryGirl.create(:chapter)
      other_chapter_users = FactoryGirl.create_list(:chapter_user, 3, chapter: other_chapter)

      visit admin_chapter_users_path(chapter)
      chapter_users.each do |cu|
        expect(page).to have_content cu.name
        expect(page).to have_content cu.email
      end

      other_chapter_users.each do |ocu|
        expect(page).not_to have_content ocu.name
        expect(page).not_to have_content ocu.email
      end
    end
  end

  context "Chapters" do
    let(:name) { Faker::Lorem.sentence }
    let(:description) { Faker::Lorem.paragraph }

    it "Allows an admin to create a new chapter" do
      visit admin_path
      click_link "Create new chapter"
      fill_in :chapter_name, with: name
      fill_in :chapter_description, with: description

      expect { click_button "Save" }.to change { Chapter.count }.by 1
      expect(Chapter.last.name).to eq name
      expect(Chapter.last.description).to eq description
    end

    it "Allows an admin to edit an existing chapter" do
      chapter = FactoryGirl.create(:chapter)
      expect(chapter.name).not_to eq name
      expect(chapter.description).not_to eq description

      visit edit_admin_chapter_path(chapter)
      fill_in :chapter_name, with: name
      fill_in :chapter_description, with: description
      click_button "Save"

      chapter.reload
      expect(chapter.name).to eq name
      expect(chapter.description).to eq description
    end
  end
end
