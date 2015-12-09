class ProfilesController < ApplicationController
  def show
    @user = current_user.decorate
  end

  def edit
    authorize! :edit, current_user
  end

  def update
    authorize! :edit, current_user
    if current_user.update_attributes(profile_params)
      redirect_to profile_path, notice: "Profile updated!"
    else
      redirect_to :back, alert: "Sorry, your profile could not be updated."
    end
  end

  protected

  def profile_params
    params.require(:user).permit(:name, :email, :telephone, :bio, :life_skills, :language_skills, :postcode)
  end
end
