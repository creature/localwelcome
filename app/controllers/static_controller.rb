class StaticController < ApplicationController
  def index
    @chapters = Chapter.includes(:subscriptions).sort { |a, b| b.subscriptions.count <=> a.subscriptions.count }
  end

  def about
  end

  def howitworks
  end
end
