class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id]).decorate
    @invite = Invitation.find_by(user: current_user, event: @event)
    @placeholders = ["I'd like to meet someone who can help me with my English.",
                     "I'd like to meet someone working in the medical field who can help me find work as a doctor.",
                     "I'd like to help someone find a job", "I'd like to help someone with their language skills.",
                     "I'd like to meet someone who can help me continue my university degree in the UK."]

    redirect_to root_path and return unless @event.published?
  end
end
