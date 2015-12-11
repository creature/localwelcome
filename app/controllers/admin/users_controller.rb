class Admin::UsersController < Admin::AdminController
  before_filter :set_chapter
  before_filter :check_permissions

  def index
    @subscriptions = @chapter.subscriptions.newest
  end

  def show
    @user = @chapter.find_user(params[:id]).decorate
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_chapter_path(@chapter), alert: "That user is not a member of this chapter."
  end

  def create_organiser
    user = @chapter.find_user(params[:user_id])
    if user.roles.create(role: :chapter_organiser, chapter: @chapter)
      redirect_to :back, notice: "Successfully added organiser."
    else
      redirect_to :back, alert: "Couldn't add as organiser."
    end
  end

  def destroy_organiser
    user = @chapter.find_user(params[:user_id])
    role = user.roles.chapter_organisers.find_by(chapter: @chapter)
    if role.destroy

      redirect_to :back, notice: "Removed organiser from this chapter."
    else
      redirect_to :back, alert: "Couldn't remove user as organiser."
    end
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
