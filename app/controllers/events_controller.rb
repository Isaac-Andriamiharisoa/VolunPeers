class EventsController < ApplicationController

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
    @participation = Participation.new
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @participation = Participation.new
    @participation.event = @event
    @participation.user = current_user
    if @event.save && @participation.save
      redirect_to event_path(@event)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :latitude, :longitude, :start_date, :end_date)
  end


end
