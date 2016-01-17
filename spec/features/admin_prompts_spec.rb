require 'rails_helper'

feature "Admin prompts (to help them fix common omissions)" do
  let(:chapter) { FactoryGirl.create(:chapter) }
  let(:organiser) { FactoryGirl.create(:chapter_organiser, chapter: chapter) }
  let(:user) { FactoryGirl.create(:user) }
  let(:event) { FactoryGirl.create(:event, chapter: chapter) }

  before { login(organiser) }

  scenario "A chapter organiser for a chapter without a description sees a prompt" do
    visit root_path
    expect(page).not_to have_selector ".banner"

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

  scenario "A chapter organiser for a group without an upcoming event sees a prompt"
  scenario "A chapter organiser whose next event is unpublished sees a prompt"
  scenario "A chapter organiser for a group whose upcoming event has no description sees a prompt"
  scenario "A chapter organiser for a group whose upcoming event has no attendee info sees a prompt"
  scenario "A chapter organiser who hasn't sent emails for their next event sees a prompt"
end
