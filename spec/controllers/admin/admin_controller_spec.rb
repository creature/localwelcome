require 'rails_helper'

describe Admin::AdminController do
  it_behaves_like "An admin-only section", :index
end
