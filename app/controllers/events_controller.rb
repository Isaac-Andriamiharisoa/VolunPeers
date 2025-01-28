class EventsController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:search] && params[:search] != ""
      @events = Event.where('title ILIKE ? OR description ILIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
    else
      @events = Event.all.limit(500)
    end
  end

  def show
    @event = Event.find(params[:id])
    @exist_participation = Participation.find_by(event_id: params[:id], user: current_user)
    @participation = @exist_participation || Participation.new
    @owner = User.find(@event.user_id)
    @markers = [{ lat: @event.latitude, lng: @event.longitude }]
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user

    if @event.save
      @participation = Participation.new
      @participation.update(user: current_user, event: @event).save
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
    params[:event]["contact"] = params[:event]["contact"].to_s.gsub(/\D/, '').to_i
    params.require(:event).permit(:title, :description, :start_date, :end_date, :start_time,
                                  :end_time, :country, :address, :contact, :photo, :action, :quantity)
  end
end
