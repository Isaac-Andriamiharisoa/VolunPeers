class EventsController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:search] && params[:search] != ""
      @events = Event.where('title ILIKE ? OR description ILIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
    else
      @events = Event.all
    end
  end

  def show
    @event = Event.find(params[:id])
    @exist_participation = Participation.where(event_id: params[:id])
    @participation = Participation.new
    @owner = User.find(@event.user_id)
    @markers = [{ lat: @event.latitude, lng: @event.longitude }]
  end

  def participants
    @event = Event.find(params[:event_id])
    @participants = @event.users
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user

    if @event.save
      @participation = Participation.new
      @participation.user = current_user
      @participation.event = @event
      @participation.save
      current_user.update(role: 'owner') if current_user.normal?
      redirect_to event_path(@event)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.update(event_params)
    redirect_to event_path(@event)
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to dashboard_path
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :start_date, :end_date, :start_time,
                                  :end_time, :country, :address, :contact, :photo, :action, :quantity)
  end
end
