require 'rails_helper'

feature "Managing subscriptions to chapters" do
  let(:user) { FactoryGirl.create(:user) }
  let!(:chapters) { FactoryGirl.create_list(:chapter, 3) }
  before { login(user) }

  scenario "You must be logged in to access the page" do
    visit subscriptions_path
    expect(current_path).to eq subscriptions_path

    logout(:user)

    visit subscriptions_path
    expect(current_path).not_to eq subscriptions_path
  end

  scenario "A user can view all the chapters on one page" do
    visit subscriptions_path
    chapters.each { |c| expect(page).to have_button c.name }
  end

  scenario "A user can join a chapter" do
    chosen_chapter = chapters.sample
    expect(user.subscribed_to? chosen_chapter).to be false

    visit subscriptions_path
    expect {
      click_button "Get emails from Local Welcome #{chosen_chapter.name}"
    }.to change { Subscription.count }.by 1
    expect(user.subscribed_to? chosen_chapter).to be true
  end

  scenario "A user can leave a chapter" do
    chosen_chapter = chapters.sample
    user.subscriptions.create(chapter: chosen_chapter)
    expect(user.subscribed_to? chosen_chapter).to be true

    visit subscriptions_path
    expect {
      click_button "Subscribed to Local Welcome #{chosen_chapter.name}"
    }.to change { Subscription.count }.by(-1)
    expect(user.subscribed_to? chosen_chapter).to be false
  end

  scenario "A user can see which chapters they're a member of" do
    chosen_chapter = chapters.sample
    user.subscriptions.create(chapter: chosen_chapter)


    visit subscriptions_path
    expect(page).to have_button "Subscribed to Local Welcome #{chosen_chapter.name}"
    expect(page.find(".subscribed")).to have_selector ".btn-success"
  end
end
