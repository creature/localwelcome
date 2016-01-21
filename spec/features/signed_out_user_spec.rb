require 'rails_helper'

feature "Signed-out user experience" do
  scenario "An anonymous user sees a button to learn more" do
    visit root_path
    within(".overview") { expect(page).to have_link "Learn more" }
  end

  scenario "An anonymous user can reach a page to find out more" do
    visit root_path
    within(".overview") { click_link "Learn more" }
    expect(current_path).to eq how_it_works_path
    expect(page).to have_content "How it works"
    expect(page).to have_content "Attending an event"
    expect(page).to have_link "Find a group near you"
  end

  scenario "An anonymous user can find out more about the project" do
    visit root_path
    click_link "about the project"
    expect(current_path).to eq about_path
    expect(page).to have_content "Ben Pollard"
  end
end
