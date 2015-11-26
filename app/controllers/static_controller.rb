class StaticController < ApplicationController
  def index
    @chapters = Chapter.all
  end
end
