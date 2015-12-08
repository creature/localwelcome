class Admin::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin_or_organiser

  def index
    if current_user.admin?
      @chapters = Chapter.all.includes(:users)
      @events = Event.all
      @users = User.all
    elsif current_user.organiser?
      @chapters = current_user.organised_chapters
    end
  end

  protected

  def verify_admin_or_organiser
    unless current_user.admin? || current_user.organiser?
      render text: "unauthorized", status: :unauthorized and return
    end
  end
end
