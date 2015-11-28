class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chapters = Chapter.all
  end

  def create
    @subscription = Subscription.new(subscription_params.merge(user: current_user))
    if @subscription.save
      redirect_to :back, notice: "Successfully joined #{@subscription.chapter.name}'s mailing list."
    else
      redirect_to :back, alert: "Sorry, something went wrong."
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    if @subscription.user == current_user
      if @subscription.destroy
        redirect_to :back, notice: "You left #{@subscription.chapter.name}'s mailing list."
      else
        redirect_to :back, alert: "Sorry, something went wrong."
      end
    else
      render :unauthorized
    end
  end

  protected

  def subscription_params
    params.require(:subscription).permit(:chapter_id)
  end
end
