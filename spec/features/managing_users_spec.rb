require 'rails_helper'

feature "Managing users" do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:chapter) { FactoryGirl.create(:chapter) }
  let!(:user) { FactoryGirl.create(:chapter_organiser, chapter: chapter) }
  let!(:subscription) { FactoryGirl.create(:subscription, user: user, chapter: chapter) }

  before { login(admin) }

  scenario "An admin viewing a chapter organiser profile only sees that chapter listed once" do
    visit admin_chapter_user_path(chapter, user)
    expect(page).to have_content("#{chapter.name} (Organiser)", count: 1)
  end
end
