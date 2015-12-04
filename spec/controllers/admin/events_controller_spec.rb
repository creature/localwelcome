require 'rails_helper'

describe Admin::EventsController do
  let(:event) { FactoryGirl.create(:event) }

  describe "GET #show" do
    it_behaves_like "An admin-only section", :show do
      let(:opts) { {chapter_id: event.chapter.id, id: event.id} }
    end
  end

  describe "GET #edit" do
    it_behaves_like "An admin-only section", :edit do
      let(:opts) { {chapter_id: event.chapter.id, id: event.id} }
    end
  end
end
