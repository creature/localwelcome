require 'rails_helper'

describe Admin::ChaptersController do
  let(:chapter) { FactoryGirl.create(:chapter) }

  describe "GET #show" do
    it_behaves_like "An admin-only section", :show do
      let(:opts) { {id: chapter.id} }
    end
  end
end
