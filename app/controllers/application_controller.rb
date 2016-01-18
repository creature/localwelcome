class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :force_empty_profiles_to_fill_out_info

  def force_empty_profiles_to_fill_out_info
    whitelisted = [edit_profile_path, profile_path, destroy_user_session_path]
    if current_user && current_user.profile_completion_score < 0.0001 && !whitelisted.include?(request.path)
      flash[:alert] = "You need to fill out your profile before continuing."
      redirect_to edit_profile_path
    end
  end

  # Change the locale to Arabic if we're on a subdomain like ar.local-welcome.org
  def set_locale
    if arabic_request?
      I18n.locale = "ar"
    else
      I18n.locale = I18n.default_locale
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: "You're not allowed to do that."
  end
end
