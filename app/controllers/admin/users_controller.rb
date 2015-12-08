class Admin::UsersController < Admin::AdminController
  before_filter :set_chapter
  before_filter :check_permissions

  def index
    @subscriptions = @chapter.subscriptions.newest
  end

  protected

  def set_chapter
    @chapter = Chapter.find(params[:chapter_id])
  end

  def check_permissions
    unless can? :manage, @chapter
      redirect_to admin_path, alert: "You don't have permission to do that."
    end
  end
end
