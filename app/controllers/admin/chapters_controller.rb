class Admin::ChaptersController < Admin::AdminController
  load_and_authorize_resource
  before_filter :check_permissions

  def show
  end

  def new
  end

  def create
    @chapter = Chapter.new(chapter_params)
    if @chapter.save
      redirect_to admin_chapter_path(@chapter), notice: "Local Welcome #{@chapter.name} chapter created successfully."
    else
      render :new, alert: "Couldn't save this chapter."
    end
  end

  def edit
  end

  def update
    if @chapter.update_attributes(chapter_params)
      redirect_to admin_chapter_path(@chapter), notice: "Local Welcome #{@chapter.name} updated successfully."
    else
      render :edit, alert: "Couldn't save this chapter."
    end
  end

  protected

  def chapter_params
    params.require(:chapter).permit(:name, :description)
  end

  def check_permissions
    unless can? :manage, @chapter
      redirect_to admin_path, alert: "You don't have permission to do that."
    end
  end
end
