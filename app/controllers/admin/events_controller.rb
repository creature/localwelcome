class Admin::EventsController < ApplicationController
  before_action :set_chapter
  before_action :set_event, except: [:create]

  def show
  end

  def create
    @event = Event.new(event_params.merge(chapter: @chapter))
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

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :starts_at, :ends_at, :published)
  end
end
