class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :force_empty_profiles_to_fill_out_info

  def force_empty_profiles_to_fill_out_info
    whitelisted = [edit_profile_path, profile_path, destroy_user_session_path]
    if current_user && current_user.profile_completion_score < 0.0001 && !whitelisted.include?(request.path)
      flash[:alert] = "You need to fill out your profile before continuing."
      redirect_to edit_profile_path
    end
  end
end
