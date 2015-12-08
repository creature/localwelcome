class Admin::ChaptersController < Admin::AdminController
  load_and_authorize_resource
  before_filter :check_permissions

  def show
  end

  protected

  def check_permissions
    unless can? :manage, @chapter
      redirect_to admin_path, alert: "You don't have permission to do that."
    end
  end
end
