class Admin::EventsController < Admin::AdminController
  before_action :set_chapter
  before_action :set_event
  load_and_authorize_resource :event
  before_action :check_permissions

  def show
    @event = @event.decorate
    @invitations = @event.invitations.includes(:user)
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

  # Send emails to this chapter's members about the given event.
  def announcement
    if @event.announced?
      redirect_to :back, alert: "Announcement emails have already been sent."
    else
      @chapter.users.each do |u|
        EventMailer.announcement(u, @event).deliver_now
      end
      @event.update_attributes(announced: true)
      redirect_to :back, notice: "Emails sent."
    end
  end

  protected

  def set_chapter
    @chapter = Chapter.find(params[:chapter_id])
  end

  # Some non-RESTful actions end up with an :event_id param instead.
  def set_event
    @event = Event.find(params[:event_id]) if params.has_key? :event_id
  end

  def check_permissions
    unless can? :manage, @event
      redirect_to admin_path, alert: "You're not allowed to access that."
    end
  end

  def event_params
    params.require(:event).permit(:name, :description, :email_info, :starts_at, :ends_at, :published, :capacity, :venue_name, :venue_postcode, :venue_info).merge({chapter_id: @chapter.id})
  end
end
