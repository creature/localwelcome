require 'rails_helper'

shared_examples "An admin-only section" do |action|
  let (:user) { FactoryGirl.create(:user) }
  let (:admin) { FactoryGirl.create(:admin) }

  it "Allows an admin user to access #{action}" do
    sign_in admin
    if defined? opts
      get action, opts
    else
      get action
    end
    expect(response).to be_success
  end

  it "Does not allow a regular user to access #{action}" do
    sign_in user
    if defined? opts
      get action, opts
    else
      get action
    end
    expect(response).not_to be_success
  end

  it "Does not allow a logged-out user to access #{action}" do
    if defined? opts
      get action, opts
    else
      get action
    end
    expect(response).not_to be_success
  end
end
