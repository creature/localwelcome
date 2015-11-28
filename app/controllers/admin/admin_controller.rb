class Admin::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin

  def index
    @chapters = Chapter.all.includes(:users)
    @events = Event.all
    @users = User.all
  end

  protected

  def verify_admin
    unless current_user.admin?
      render text: "unauthorized", status: :unauthorized and return
    end
  end
end
