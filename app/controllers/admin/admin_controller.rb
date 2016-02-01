class Admin::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin_or_organiser

  def index
    if current_user.admin?
      @chapters = Chapter.all.includes(:users).includes(:subscriptions).sort { |a, b| b.subscriptions.count <=> a.subscriptions.count }
      @events = Event.all
      @users = User.all.includes(:chapters).newest_first
      @users_in_chapter_count = @users.select(&:in_chapter?).count
      @organisers = Role.chapter_organisers.includes(:user).map(&:user)
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
