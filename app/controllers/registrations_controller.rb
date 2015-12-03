class RegistrationsController < Devise::RegistrationsController
  # Show a "Sign up for Local Welcome" page.
  def new
    @chapter_id = params[:chapter]
    super
  end

  # Create a new user, along with a subscription for a chapter if they came via a chapter page.
  def create
    super
    if params[:chapter_id] && Chapter.exists?(params[:chapter_id])
      resource.subscriptions.create(chapter_id: params[:chapter_id])
    end
  end

  protected

  # Redirect the user to the subscriptions path after signup.
  def after_sign_up_path_for(resource)
    subscriptions_path
  end
end
