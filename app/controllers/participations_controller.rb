class ParticipationsController < ApplicationController

  def create
    @participation = Participation.new
    @participation.event_id = params[:event_id].to_i
    @participation.user = current_user
    @participation.save
    redirect_to root_path
  end
end
