require 'rails_helper'

describe Admin::AdminController do
  let (:user) { FactoryGirl.create(:user) }
  let (:admin) { FactoryGirl.create(:admin) }

  describe "GET #index" do
    it "Allows an admin user to access the dashboard" do
      sign_in admin
      get :index
      expect(response).to be_success
    end

    it "Does not allow a regular user to access the dashboard" do
      sign_in user
      get :index
      expect(response).not_to be_success
    end

    it "Does not allow a logged-out user to access the dashboard" do
      get :index
      expect(response).not_to be_success
    end
  end
end
