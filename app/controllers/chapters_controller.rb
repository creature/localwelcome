class ChaptersController < ApplicationController
  def show
    @chapter = Chapter.find(params[:id])
    @next_event = @chapter.upcoming_events.published.first
  end
end
