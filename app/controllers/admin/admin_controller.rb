class Admin::AdminController < ApplicationController
  before_action :authenticate_user!

  def index
    @chapters = Chapter.all
    @events = Event.all
  end
end
