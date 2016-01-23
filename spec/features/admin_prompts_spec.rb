require 'rails_helper'

feature "Admin prompts (to help them fix common omissions)" do
  let(:chapter) { FactoryGirl.create(:chapter) }
  let(:organiser) { FactoryGirl.create(:chapter_organiser, chapter: chapter) }
  let(:user) { FactoryGirl.create(:chapter_user, chapter: chapter) }
  let!(:event) { FactoryGirl.create(:announced_event, chapter: chapter) }

  before { login(organiser) }

  scenario "A chapter organiser for a chapter where everything is hunky dory doesn't see a prompt" do
    visit root_path
    expect(page).not_to have_selector ".banner"
  end

  scenario "A chapter organiser for a chapter without a description sees a prompt" do
    chapter.update_attributes(description: nil)
    visit root_path
    expect(page).to have_selector ".banner"
    expect(page).to have_content "missing a description"

    chapter.update_attributes(description: "")
    visit root_path
    expect(page).to have_selector ".banner"
  end

  scenario "A regular user looking at a chapter without a description doesn't see a prompt" do
    chapter = FactoryGirl.create(:chapter_without_description)
    logout(:user)
    login(user)
    visit chapter_path(chapter)
    expect(page).not_to have_selector ".banner"
    expect(page).not_to have_content "missing a description"
  end

  scenario "A chapter organiser whose next event is unpublished sees a prompt" do
    event.update_attributes(published: false)

    visit root_path
    expect(page).to have_selector ".banner"
    expect(page).to have_content "has an unpublished upcoming event"
  end

  scenario "A chapter organiser for a group without an upcoming event sees a prompt" do
    event.destroy

    visit root_path
    expect(page).to have_selector ".banner"
    expect(page).to have_content "no upcoming events"
  end

  scenario "A chapter organiser for a group whose upcoming event has no description sees a prompt" do
    event.update_attributes(description: nil)

    visit root_path
    expect(page).to have_selector ".banner"
    expect(page).to have_content "has no description"
  end

  scenario "A chapter organiser for a group whose upcoming event has no attendee info sees a prompt" do
    event.update_attributes(email_info: nil)

    visit root_path
    expect(page).to have_selector ".banner"
    expect(page).to have_content "has no attendee info"
  end

  scenario "A chapter organiser who hasn't sent emails for their next event sees a prompt" do
    event.update_attributes(announced: false)

    visit root_path
    expect(page).to have_selector ".banner"
    expect(page).to have_content "hasn't been announced yet"
  end
end
