require 'rails_helper'

feature "Signing Up to Local Welcome" do
  let(:chapter) { FactoryGirl.create(:chapter) }
  let(:user) { FactoryGirl.create(:user) }
  let(:chapter_user) { FactoryGirl.create(:chapter_user, chapter: chapter) }
  let(:email) { Faker::Internet.safe_email }
  let(:password) { Faker::Lorem.characters(10) }

  scenario "Signing up works" do
    visit new_user_registration_path
    fill_in_registration_form

    expect { click_button "Sign up" }.to change { User.count }.by 1
  end

  scenario "After sign up, a user is prompted to fill out their profile" do
    visit new_user_registration_path
    fill_in_registration_form
    click_button "Sign up"

    expect(page).to have_success_notice
    expect(page).not_to have_error_notice
    expect(current_path).to eq edit_profile_path
  end

  scenario "Signing up doesn't create a subscription automatically" do
    visit new_user_registration_path
    fill_in_registration_form

    expect { click_button "Sign up"}.not_to change { Subscription.count }
  end

  context "Signing up from a chapter page" do
    scenario "Signing up subscribes the user to a given mailing list" do
      visit chapter_path(chapter)
      click_link "Sign up to Local Welcome #{chapter.name}"
      fill_in_registration_form

      expect { click_button "Sign up" }.to change { Subscription.count }.by 1
      subscription = Subscription.first
      expect(subscription.user).to be
      expect(subscription.chapter).to eq chapter
    end

    scenario "Signing up with an invalid chapter ID doesn't result in errors" do
      visit new_user_registration_path(chapter: 4567)
      fill_in_registration_form
      expect { click_button "Sign up" }.not_to change { Subscription.count }
      expect(User.where(email: email).exists?).to be true
    end

    scenario "Signing up with a too-short password doesn't result in an application error" do
      visit chapter_path(chapter)
      click_link "Sign up to Local Welcome #{chapter.name}"
      fill_in :user_email, with: email
      fill_in :user_password, with: "asdf"
      fill_in :user_password_confirmation, with: "asdf"

      expect { click_button "Sign up" }.not_to change { User.count }
      expect(current_path).to eq user_registration_path
      expect(page).to have_selector "#error_explanation"
      expect(page).to have_selector "form[action='#{user_registration_path}']"
    end

    scenario "A user ends up being auto-subscribed to their chosen chapter if they bounce off an error page first" do
      visit chapter_path(chapter)
      click_link "Sign up to Local Welcome #{chapter.name}"
      fill_in :user_email, with: email
      fill_in :user_password, with: "asdf"
      fill_in :user_password_confirmation, with: "asdf"
      click_button "Sign up" # First attempt at signing up, but the password's too short
      fill_in :user_password, with: password
      fill_in :user_password_confirmation, with: password

      expect { click_button "Sign up" }.to change { User.count }.by 1
      expect(User.last.subscriptions.count).to be 1
      expect(User.last.chapters.first).to eq chapter
      expect(current_path).to eq edit_profile_path
    end

  end

  context "The nag bar for people who aren't a member of any chapters" do
    scenario "A logged-out user doesn't see a nag bar" do
      visit root_path
      expect(page).not_to have_selector(".no-chapters.banner")
    end

    scenario "A user who hasn't joined any chapters sees a nag bar" do
      login(user)
      visit root_path
      expect(page).to have_selector(".no-chapters.banner")
    end

    scenario "A user who's joined at least one chapter doesn't see a nag bar" do
      login(chapter_user)
      visit root_path
      expect(page).not_to have_selector(".no-chapters.banner")
    end
  end
end

def fill_in_registration_form
  fill_in :user_email, with: email
  fill_in :user_password, with: password
  fill_in :user_password_confirmation, with: password
end

