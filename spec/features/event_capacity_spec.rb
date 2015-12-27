require 'rails_helper'

feature "Event capacity limits" do
  let(:event) { FactoryGirl.create(:event, capacity: 3) }
  let(:full_event) { FactoryGirl.create(:full_event, capacity: 3) }
  let(:users) { FactoryGirl.create_list(:user, 5) }
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  before { login user }

  scenario "Event capacity doesn't affect the number of invites we can create" do
    users.each do |u|
      logout(:user)
      login(u)
      visit chapter_event_path(event.chapter, event)

      expect { click_button "Request an invite" }.to change { Invitation.count }.by 1
    end
  end

  scenario "A user can request an invite to an event with free capacity" do
    visit chapter_event_path(event.chapter, event)
    expect { click_button "Request an invite" }.to change { Invitation.count }.by 1
  end

  scenario "A user can accept an invite to an event with free capacity" do
    unaccepted_invite = FactoryGirl.create(:sent_invitation, event: event, user: user)

    expect(user.attending? event).to be false
    visit accept_invitation_path(unaccepted_invite.token)
    expect(user.attending? event).to be true
  end

  scenario "A user cannot request an invite to a full event" do
    visit chapter_event_path(full_event.chapter, full_event)
    expect(page).to have_content "event is full"
    expect(page).not_to have_button "Request an invite"
  end

  scenario "A user cannot accept an invite to a full event" do
    unaccepted_invite = FactoryGirl.create(:sent_invitation, event: full_event, user: user)

    expect(user.attending? full_event).to be false
    visit accept_invitation_path(unaccepted_invite.token)
    expect(user.attending? full_event).to be false
  end

  scenario "A user who cancels their attendance frees up a slot" do
    accepted_invite = full_event.invitations.accepted.sample

    expect(full_event).to be_full
    visit decline_invitation_path(accepted_invite.token)
    expect(full_event).not_to be_full
  end

  scenario "The admin panel displays the number of free slots" do
    logout(:user)
    login(admin)

    visit admin_chapter_event_path(event.chapter, event)
    expect(page).to have_content "0 of 3 slots"
    expect(page).to have_content "3 slots left"

    visit admin_chapter_event_path(full_event.chapter, full_event)
    expect(page).to have_content "3 of 3 slots"
    expect(page).to have_content "0 slots left"
    expect(page).to have_content "full"
  end

  scenario "The admin panel lets an admin edit the capacity" do
    logout(:user)
    login(admin)

    visit edit_admin_chapter_event_path(event.chapter, event)
    fill_in :event_capacity, with: 6
    click_button "Save"

    expect(page).to have_success_notice
    event.reload
    expect(event.capacity).to eq 6
  end

  scenario "An admin can't issue invitations to a full event" do
    FactoryGirl.create_list(:invitation, 3, event: full_event)
    logout(:user)
    login(admin)

    visit admin_chapter_event_path(full_event.chapter, full_event)
    expect(page).not_to have_button "Send invitation"
  end
end
