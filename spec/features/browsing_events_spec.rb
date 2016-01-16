require 'rails_helper'

feature "Browsing events" do
  let (:event) { FactoryGirl.create(:event) }
  let (:unpublished_event) { FactoryGirl.create(:unpublished_event) }
  let (:user) { FactoryGirl.create(:user) }
  let (:admin) { FactoryGirl.create(:admin) }
  let (:organiser) { FactoryGirl.create(:chapter_organiser, chapter: event.chapter) }
  let (:other_organiser) { FactoryGirl.create(:chapter_organiser) }

  scenario "An anonymous user can view a published event" do
    visit chapter_event_path(event.chapter, event)

    expect(page).to have_content event.name
    expect(page).to have_content event.description
  end

  scenario "An anonymous user cannot view an unpublished event" do
    visit chapter_event_path(unpublished_event.chapter, unpublished_event)

    expect(current_path).to eq root_path
  end

  scenario "We don't generate broken meta tags" do
    visit chapter_event_path(event.chapter, event)

    expect(page).not_to have_content 'property="og:description"'
    expect(page).to have_selector('meta[property="og:description"]', visible: false)
  end

  context "The 'manage this event' button" do
    scenario "An anonymous user doesn't see a manage button" do
      visit chapter_event_path(event.chapter, event)

      expect(page).not_to have_link "Manage this event"
    end

    scenario "A logged-in user doesn't see a manage button" do
      manage_helper(user, event, false)
    end

    scenario "A chapter organiser for a different chapter doesn't see a manage button" do
      manage_helper(other_organiser, event, false)
    end

    scenario "A chapter organiser for this chapter sees a manage button" do
      manage_helper(organiser, event, true)
    end

    scenario "An admin sees a chapter button" do
      manage_helper(admin, event, true)
    end
  end

  def manage_helper(u, event, should_see_link)
    login_as(u)
    visit chapter_event_path(event.chapter, event)

    if should_see_link
      expect(page).to have_link "Manage this event"
    else
      expect(page).not_to have_link "Manage this event"
    end
  end
end
