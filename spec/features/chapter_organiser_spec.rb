require 'rails_helper'

feature "Chapter organisers" do
  let(:chapter) { FactoryGirl.create(:chapter) }
  let(:other_chapter) { FactoryGirl.create(:chapter) }
  let(:organiser) { FactoryGirl.create(:chapter_organiser, chapter: chapter) }
  before { login(organiser) }

  scenario "Chapter organisers can access the dashboard" do
    visit admin_path
    expect(current_path).to eq admin_path
    expect(page).to have_content chapter.name
  end

  scenario "Chapter organisers don't get to see numbers for the whole system" do
    visit admin_path
    expect(page).not_to have_content "Some numbers"
  end

  scenario "Chapter organisers can view their chapter" do
    visit admin_path
    expect(page).to have_content chapter.name
    click_link chapter.name
    expect(current_path).to eq admin_chapter_path(chapter)
  end

  scenario "Chapter organisers can view events for their chapter" do
    event = FactoryGirl.create(:event, chapter: chapter)

    visit admin_path
    expect(page).to have_content event.title
    click_link event.title
    expect(current_path).to eq admin_chapter_event_path(event.chapter, event)
  end

  scenario "Chapter organisers can view members for their chapter" do
    chapter_users = FactoryGirl.create_list(:user, 3)
    chapter_users.each { |cu| FactoryGirl.create(:subscription, user: cu, chapter: chapter) }

    visit admin_chapter_path(chapter)
    chapter_users.each do |cu|
      expect(page).to have_content cu.name
      expect(page).to have_content cu.email
    end
  end

  scenario "Chapter organisers cannot view other chapters" do
    other_chapter = FactoryGirl.create(:chapter)

    visit admin_path
    expect(page).not_to have_content other_chapter.name

    visit admin_chapter_path(other_chapter)
    expect(current_path).not_to eq admin_chapter_path(other_chapter)
    expect(page).to have_error_notice
  end

  scenario "Chapter organisers cannot view events for other chapters" do
    other_event = FactoryGirl.create(:event, chapter: other_chapter)

    visit admin_path
    expect(page).not_to have_content other_event.title

    visit admin_chapter_event_path(other_event.chapter, other_event)
    expect(current_path).not_to eq admin_chapter_event_path(other_event.chapter, other_event)
    expect(page).to have_error_notice
  end

  scenario "Chapter organisers cannot view members for other chapters" do
    other_chapter = FactoryGirl.create(:chapter)
    other_chapter_users = FactoryGirl.create_list(:user, 3)
    other_chapter_users.each { |cu| FactoryGirl.create(:subscription, user: cu, chapter: other_chapter) }

    # Other chapter users shouldn't show up on this chapter's management page
    visit admin_chapter_path(chapter)
    other_chapter_users.each do |cu|
      expect(page).not_to have_content cu.name
      expect(page).not_to have_content cu.email
    end

    # Chapter organisers shouldn't be able to access the users page for other chapters.
    visit admin_chapter_path(other_chapter)
    expect(current_path).not_to eq admin_chapter_path(other_chapter)
    expect(page).to have_error_notice
  end

  scenario "Chapter organisers can create events for their chapter"
  scenario "Chapter organisers can edit events for their chapter"
end
