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

  context "Markdown support" do
    scenario "Markdown is supported on event descriptions" do
      event.update_attributes(description: "We are meeting at [a venue](https://twitch.tv/) this week. This **has moved** from last time.")
      visit chapter_event_path(event.chapter, event)

      expect(page).to have_link "a venue", href: "https://twitch.tv/"
      expect(page).to have_selector "strong", text: "has moved"
    end

    scenario "Markdown is supported in attendee-only info" do
      event.update_attributes(email_info: "Please bring _everything_ you need.")
      FactoryGirl.create(:accepted_invitation, user: user, event: event)
      login_as user
      visit chapter_event_path(event.chapter, event)

      expect(page).to have_text "Please bring everything you need"
      expect(page).to have_selector "em", text: "everything"
    end

    scenario "Markdown is supported in venue info" do
      event.update_attributes(venue_info: "We are **downstairs** this month - bring [a book](https://amazon.com/).")
      FactoryGirl.create(:accepted_invitation, user: user, event: event)
      login_as user
      visit chapter_event_path(event.chapter, event)

      expect(page).to have_selector "strong", text: "downstairs"
      expect(page).to have_link "a book", href: "https://amazon.com/"
    end
  end

  context "The 'manage this event' button" do
    scenario "An anonymous user doesn't see a manage button" do
      visit chapter_event_path(event.chapter, event)
      expect(page).not_to have_link "Manage this event"
    end

    scenario "A logged-in user doesn't see a manage button" do
      check_for_manage_event_button(user, event, false)
    end

    scenario "A chapter organiser for a different chapter doesn't see a manage button" do
      check_for_manage_event_button(other_organiser, event, false)
    end

    scenario "A chapter organiser for this chapter sees a manage button" do
      check_for_manage_event_button(organiser, event, true)
    end

    scenario "An admin sees a chapter button" do
      check_for_manage_event_button(admin, event, true)
    end
  end
end
