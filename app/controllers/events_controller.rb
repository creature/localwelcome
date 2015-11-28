class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
    @invite = Invitation.find_by(user: current_user, event: @event)
  end
end
