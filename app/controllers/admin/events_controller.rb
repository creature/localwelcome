class Admin::EventsController < Admin::AdminController
  before_action :set_chapter
  load_and_authorize_resource
  before_action :check_permissions

  def show
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to admin_chapter_event_path(@chapter, @event), notice: "Event created!"
    else
      redirect_to :back, alert: "Couldn't create event."
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to admin_chapter_event_path(@chapter, @event), notice: "Event updated!"
    else
      redirect_to :back, alert: "Couldn't update event."
    end
  end

  protected

  def set_chapter
    @chapter = Chapter.find(params[:chapter_id])
  end

  def check_permissions
    unless can? :manage, @event
      redirect_to admin_path, alert: "You're not allowed to access that."
    end
  end

  def event_params
    params.require(:event).permit(:title, :description, :email_info, :starts_at, :ends_at, :published, :capacity).merge({chapter_id: @chapter.id})
  end
end
