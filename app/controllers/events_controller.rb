class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
    @invite = Invitation.find_by(user: current_user, event: @event)

    redirect_to root_path and return unless @event.published?
  end
end
