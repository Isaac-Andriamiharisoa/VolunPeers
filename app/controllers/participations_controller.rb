class ParticipationsController < ApplicationController

  def create
    @participation = Participation.new
    @participation.event_id = params[:event_id].to_i
    @participation.user = current_user
    @participation.save
    redirect_to event_path(@participation.event_id)
  end

  def destroy
    @participation = Participation.find(params[:id])
    @participation.destroy
    redirect_to calendar_path, notice: "Your participation was cancelled"
  end
end
