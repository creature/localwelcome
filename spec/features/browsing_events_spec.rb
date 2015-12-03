require 'rails_helper'

feature "Browsing events" do
  let (:event) { FactoryGirl.create(:event) }
  let (:unpublished_event) { FactoryGirl.create(:unpublished_event) }

  scenario "An anonymous user can view a published event" do
    visit chapter_event_path(event.chapter, event)

    expect(page).to have_content event.title
    expect(page).to have_content event.description
  end

  scenario "An anonymous user cannot view an unpublished event" do
    visit chapter_event_path(unpublished_event.chapter, unpublished_event)

    expect(current_path).to eq root_path
  end
end
