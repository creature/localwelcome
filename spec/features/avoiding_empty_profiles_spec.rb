require 'rails_helper'

feature "Avoiding empty profiles" do
  let(:user) { FactoryGirl.create(:user) }
  let(:empty_user) { FactoryGirl.create(:empty_user) }
  let(:chapter) { FactoryGirl.create(:chapter) }
  let(:event) { FactoryGirl.create(:event, chapter: chapter) }
  let(:redirecting_paths) { [root_path, chapter_path(chapter), chapter_event_path(chapter, event)] }
  let(:name) { Faker::Name.name }
  let(:bio) { Faker::Lorem.paragraph }

  before { login(empty_user) }

  scenario "A user with an empty profile gets redirected to the edit page" do
    redirecting_paths.each do |rp|
      visit rp
      expect(current_path).to eq edit_profile_path
      expect(page).to have_error_notice
    end
  end

  scenario "A user with an empty profile can log out" do
    visit profile_path
    click_link "Sign out"

    expect(page).to have_success_notice
    expect(page).to have_content "Sign in"
    expect(current_path).to eq root_path
  end

  scenario "A user with an empty profile can view their profile" do
    visit profile_path
    expect(current_path).to eq profile_path
  end

  scenario "A user with an empty profile can update their profile" do
    visit edit_profile_path
    fill_in :user_name, with: name
    fill_in :user_bio, with: bio
    click_button "Save"

    empty_user.reload
    expect(empty_user.profile_completion_score).to be > 10
    expect(empty_user.name).to eq name
    expect(empty_user.bio).to eq bio
  end

  scenario "A user without an empty profile doesn't get redirected" do
    logout(:user)
    login(user)

    redirecting_paths.each do |rp|
      visit rp
      expect(current_path).to eq rp
      expect(page).not_to have_error_notice
    end
  end
end
