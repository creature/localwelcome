require 'rails_helper'

feature "Browsing chapters" do
  let(:chapter) { FactoryGirl.create(:chapter) }
  let (:user) { FactoryGirl.create(:user) }
  let (:admin) { FactoryGirl.create(:admin) }
  let (:organiser) { FactoryGirl.create(:chapter_organiser, chapter: chapter) }
  let (:other_organiser) { FactoryGirl.create(:chapter_organiser) }

  context "Markdown support" do
    scenario "Chapter descriptions support Markdown formatting" do
      chapter.update_attributes(description: "A **sample** [Markdown](http://example.com/) _description_")
      visit chapter_path(chapter)

      expect(page).to have_link "Markdown", href: "http://example.com/"
      expect(page).to have_selector "strong", text: "sample"
      expect(page).to have_selector "em", text: "description"
    end
  end

  context "The 'manage this chapter' button" do
    scenario "An anonymous user doesn't see a manage button" do
      visit chapter_path(chapter)
      expect(page).not_to have_link "Manage this event"
    end

    scenario "A logged-in user doesn't see a manage button" do
      check_for_manage_chapter_button(user, chapter, false)
    end

    scenario "A chapter organiser for a different chapter doesn't see a manage button" do
      check_for_manage_chapter_button(other_organiser, chapter, false)
    end

    scenario "A chapter organiser for this chapter sees a manage button" do
      check_for_manage_chapter_button(organiser, chapter, true)
    end

    scenario "An admin sees a chapter button" do
      check_for_manage_chapter_button(admin, chapter, true)
    end
  end
end
