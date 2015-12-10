require 'rails_helper'

feature "Signing Up to Local Welcome" do
  let(:chapter) { FactoryGirl.create(:chapter) }
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
  end
end

def fill_in_registration_form
  fill_in :user_email, with: email
  fill_in :user_password, with: password
  fill_in :user_password_confirmation, with: password
end

