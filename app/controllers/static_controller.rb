class StaticController < ApplicationController
  def index
    @chapters = Chapter.all
  end

  def about
  end

  def howitworks
  end
end
