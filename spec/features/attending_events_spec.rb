require 'rails_helper'

feature "Attending events" do
  let (:user) { FactoryGirl.create(:user) }
  let (:event) { FactoryGirl.create(:event) }

  before { login_as user }

  scenario "An unregistered user is prompted to sign up when trying to attend an event" do
    logout(:user)
    visit chapter_event_path(event.chapter, event)

    expect(page).to have_link "Sign in"
    click_link_or_button "Request an invite"
    expect(current_path).to eq new_user_session_path
  end

  scenario "A registered user can request an invite for an event" do
    visit chapter_event_path(event.chapter, event)

    expect { click_link_or_button "Request an invite" }.to change { Invitation.count }.by 1
    invite = Invitation.last

    expect(invite.user).to eq user
    expect(invite.event).to eq event
  end

  scenario "A user who has no invite doesn't see attendee-only info" do
    visit chapter_event_path(event.chapter, event)
    expect_page_not_to_have_attendee_only_info(event)
  end

  scenario "A user who hasn't been approved yet doesn't see attendee-only info" do
    FactoryGirl.create(:invitation, user: user, event: event)
    visit chapter_event_path(event.chapter, event)
    expect_page_not_to_have_attendee_only_info(event)
  end

  scenario "A user whose invite request has been declined doesn't see attendee-only info" do
    FactoryGirl.create(:declined_invitation, user: user, event: event)
    visit chapter_event_path(event.chapter, event)
    expect_page_not_to_have_attendee_only_info(event)
  end

  scenario "A user who's attending an event sees attendee-only info" do
    FactoryGirl.create(:accepted_invitation, user: user, event: event)
    visit chapter_event_path(event.chapter, event)

    expect(page).to have_content event.email_info
    expect(page).to have_content event.venue_name
    expect(page).to have_content event.venue_postcode
    expect(page).to have_content event.venue_info
  end

  def expect_page_not_to_have_attendee_only_info(event)
    expect(page).not_to have_content event.email_info
    expect(page).not_to have_content event.venue_name
    expect(page).not_to have_content event.venue_postcode
    expect(page).not_to have_content event.venue_info
  end
end
