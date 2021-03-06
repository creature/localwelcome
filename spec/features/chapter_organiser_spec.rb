require 'rails_helper'

feature "Chapter organisers" do
  let(:chapter) { FactoryGirl.create(:chapter) }
  let(:other_chapter) { FactoryGirl.create(:chapter) }
  let(:organiser) { FactoryGirl.create(:chapter_organiser, chapter: chapter) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:name) { Faker::Lorem.sentence }
  let(:description) { Faker::Lorem.paragraph }
  let(:start_time) { 12.days.from_now.beginning_of_hour }
  let(:end_time) { start_time + 3.hours }
  before { login(organiser) }

  context "Admin dashboard" do
    scenario "Chapter organisers can access the dashboard" do
      visit admin_path
      expect(current_path).to eq admin_path
      expect(page).to have_content chapter.name
    end

    scenario "Chapter organisers don't get to see numbers for the whole system" do
      visit admin_path
      expect(page).not_to have_content "Some numbers"
    end
  end

  context "Running their chapter" do
    scenario "Chapter organisers can view their chapter" do
      visit admin_path
      expect(page).to have_content chapter.name
      click_link chapter.name
      expect(current_path).to eq admin_chapter_path(chapter)
    end

    scenario "Chapter organisers can view events for their chapter" do
      event = FactoryGirl.create(:event, chapter: chapter)
      visit admin_path
      expect(page).to have_content event.name
      click_link event.name
      expect(current_path).to eq admin_chapter_event_path(event.chapter, event)
    end

    scenario "Chapter organisers can view members for their chapter" do
      chapter_users = FactoryGirl.create_list(:user, 3)
      chapter_users.each { |cu| FactoryGirl.create(:subscription, user: cu, chapter: chapter) }

      visit admin_chapter_path(chapter)
      chapter_users.each do |cu|
        expect(page).to have_content cu.name
        expect(page).to have_content cu.email
      end
    end

    scenario "Chapter organisers can create events for their chapter" do
      visit admin_chapter_path(chapter)
      fill_in_event_form(name, description, start_time, end_time)
      expect { click_button "Create new event" }.to change { chapter.events.count }.by 1
      new_event = chapter.events.last

      expect(new_event.name).to eq name
      expect(new_event.starts_at).to eq start_time
    end

    scenario "Chapter organisers can edit events for their chapter" do
      event = FactoryGirl.create(:event, chapter: chapter)
      visit edit_admin_chapter_event_path(event.chapter, event)
      fill_in_event_form(name, description, start_time, end_time)
      click_button "Save"

      expect(page).to have_success_notice
      expect(current_path).to eq admin_chapter_event_path(event.chapter, event)
      event.reload
      expect(event.name).to eq name
      expect(event.starts_at).to eq start_time
    end
  end

  context "Keeping details of other chapters secure" do
    scenario "Chapter organisers cannot view other chapters" do
      other_chapter = FactoryGirl.create(:chapter)

      visit admin_path
      expect(page).not_to have_content other_chapter.name

      visit admin_chapter_path(other_chapter)
      expect(current_path).not_to eq admin_chapter_path(other_chapter)
      expect(page).to have_error_notice
    end

    scenario "Chapter organisers cannot view events for other chapters" do
      other_event = FactoryGirl.create(:event, chapter: other_chapter)

      visit admin_path
      expect(page).not_to have_content other_event.name

      visit admin_chapter_event_path(other_event.chapter, other_event)
      expect(current_path).not_to eq admin_chapter_event_path(other_event.chapter, other_event)
      expect(page).to have_error_notice
    end

    scenario "Chapter organisers cannot view members for other chapters" do
      other_chapter = FactoryGirl.create(:chapter)
      other_chapter_users = FactoryGirl.create_list(:user, 3)
      other_chapter_users.each { |cu| FactoryGirl.create(:subscription, user: cu, chapter: other_chapter) }

      # Other chapter users shouldn't show up on this chapter's management page
      visit admin_chapter_path(chapter)
      other_chapter_users.each do |cu|
        expect(page).not_to have_content cu.name
        expect(page).not_to have_content cu.email
      end

      # Chapter organisers shouldn't be able to access the users page for other chapters.
      visit admin_chapter_path(other_chapter)
      expect(current_path).not_to eq admin_chapter_path(other_chapter)
      expect(page).to have_error_notice
    end
  end

  context "Keeping user details secure" do
    let!(:users) { FactoryGirl.create_list(:user, 3) }

    scenario "Chapter organisers shouldn't be able to access the global user list" do
      visit admin_users_path

      expect(current_path).not_to eq admin_users_path
      expect(page).to have_error_notice
      users.each do |u|
        expect(page).not_to have_content u.name
        expect(page).not_to have_content u.email
      end
    end

    scenario "Chapter organisers shouldn't be able to access the global user show page" do
      users.each do |u|
        visit admin_user_path(u)

        expect(current_path).not_to eq admin_user_path(u)
        expect(page).to have_error_notice
        expect(page).not_to have_content u.name
        expect(page).not_to have_content u.email
      end
    end
  end

  context "Admins managing chapter organisers" do
    before do
      logout(:user)
      login(admin)
    end

    scenario "An admin can add a new chapter organiser" do
      target_user = FactoryGirl.create(:chapter_user, chapter: chapter)
      expect(target_user).not_to be_organiser

      visit admin_chapter_user_path(chapter, target_user)
      click_link "Make organiser"

      expect(target_user).to be_organiser
      expect(target_user.organiser_of? chapter).to be true
    end

    scenario "An admin can revoke a chapter organiser permission" do
      expect(organiser).to be_organiser
      visit admin_chapter_user_path(chapter, organiser)
      click_link "Remove as organiser"

      expect(organiser).not_to be_organiser
    end
  end
end
