class Admin::AdminController < ApplicationController
  before_action :authenticate_user!

  def index
    @chapters = Chapter.all.includes(:users)
    @events = Event.all
    @users = User.all
  end
end
