require 'rails_helper'

feature "Managing users" do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:chapter) { FactoryGirl.create(:chapter) }
  let(:chapter_organiser) { FactoryGirl.create(:chapter_organiser, chapter: chapter) }
  let(:event) { FactoryGirl.create(:event, chapter: chapter) }
  let!(:invite) { FactoryGirl.create(:invitation, event: event) }
  let!(:user) { FactoryGirl.create(:chapter_organiser, chapter: chapter) }
  let!(:subscription) { FactoryGirl.create(:subscription, user: user, chapter: chapter) }

  before { login(admin) }

  scenario "An admin viewing a chapter organiser profile only sees that chapter listed once" do
    visit admin_chapter_user_path(chapter, user)
    expect(page).to have_content("#{chapter.name} (Organiser)", count: 1)
  end

  scenario "An admin can flag a user as 'more info required'" do
    check_user_can_be_flagged
  end

  scenario "A chapter organiser can flag a user as 'more info required'" do
    logout :user
    login chapter_organiser
    check_user_can_be_flagged
  end

  scenario "A user receives an email when flagged as 'more info required'" do
    visit admin_chapter_event_path(event.chapter, event)
    expect { click_button "More profile info required" }.to change { ActionMailer::Base.deliveries.count }.by 1
    expect(ActionMailer::Base.deliveries.last.to).to include invite.user.email
  end

  scenario "A user flagged as 'more info required' sees a persistent message asking for more info." do
    user = FactoryGirl.create(:user, more_info_required: true)
    logout :user
    login user

    visit root_path
    expect(page).to have_selector ".more-info-required.banner"
    visit chapter_event_path(event.chapter, event)
    expect(page).to have_selector ".more-info-required.banner"

    user.update_attributes(more_info_required: false)
    visit root_path
    expect(page).not_to have_selector ".more-info-required.banner"
  end

  def check_user_can_be_flagged
    visit admin_chapter_event_path(event.chapter, event)
    expect(page).not_to have_content "More profile information requested"
    expect(page).to have_button "More profile info required", count: 1
    click_button "More profile info required"

    expect(page).to have_success_notice
    expect(page).to have_content "More profile information requested"
    invite.user.reload
    expect(invite.user).to be_more_info_required
  end
end
