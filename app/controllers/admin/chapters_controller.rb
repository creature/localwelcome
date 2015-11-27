class Admin::ChaptersController < ApplicationController
  before_action :set_chapter, except: :new

  def show
  end

  protected

  def set_chapter
    @chapter = Chapter.find(params[:id])
  end
end
