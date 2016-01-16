require 'rails_helper'

feature "Managing chapters" do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:chapter) { FactoryGirl.create(:chapter) }
  let(:other_chapter) { FactoryGirl.create(:chapter) }
  let(:chapter_organiser) { FactoryGirl.create(:chapter_organiser, chapter: chapter) }
  let(:name) { Faker::Address.city }
  let(:description) { Faker::Lorem.paragraph }

  before do
    login(admin)
    visit admin_chapter_path(chapter)
  end

  context "Editing chapters" do
    scenario "An admin should see an 'edit' button" do
      expect(page).to have_link "Edit"
    end

    scenario "A chapter organiser should see an 'edit' button" do
      logout(:user)
      login_as chapter_organiser
      expect(page).to have_link "Edit"
    end

    scenario "An admin should be able to edit a chapter" do
      edit_chapter
      ensure_chapter_updated
    end

    scenario "A chapter organiser should be able to edit their chapter" do
      logout(:user)
      login_as chapter_organiser

      edit_chapter
      ensure_chapter_updated
    end

    scenario "A chapter organiser should not be able to edit other chapters" do
      logout(:user)
      login_as chapter_organiser

      visit edit_admin_chapter_path(other_chapter)
      expect(current_path).not_to eq edit_admin_chapter_path(other_chapter)
      expect(page).to have_error_notice
    end
  end

  scenario "A user can easily get to the page for a chapter from the admin interface" do
    expect(page).to have_link "View on site"
  end

  protected

  # Navigate to the "edit" form and fill it out
  def edit_chapter
    visit admin_chapter_path(chapter)
    click_link_or_button "Edit"
    fill_in :chapter_name, with: name
    fill_in :chapter_description, with: description
    click_link_or_button "Save"
  end

  # Make sure page has new chapter content, and the chapter model got updated in the DB.
  def ensure_chapter_updated
    expect(page).to have_success_notice
    expect(page).to have_content name
    expect(page).to have_content description

    chapter.reload
    expect(chapter.name).to eq name
    expect(chapter.description).to eq description
  end
end
