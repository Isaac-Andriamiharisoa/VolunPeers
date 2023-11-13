class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @testimonials = Testimonial.all.limit(3).order(created_at: :desc)
    @event = Event.all.order(start_date: :asc).limit(1)
    @user = User.first
  end

  def calendar
    if params[:search].present? && params[:search] != ""
      @participations = participated_event_search
    else
      @participations = global_events
    end
  end

  def dashboard
    if params[:search].present? && params[:search] != ""
      @participations = participated_event_search
    else
      @participations = global_events
    end
    @events_count = past_events.count
    @past_events = past_events

    if params[:created_search].present? && params[:created_search] != ""
      @created_events = search_created_events
    else
      @created_events = created_events
    end
  end

  private

  def global_events
    Participation.joins(:event).where(participations: { user_id: current_user.id })
  end

  def participated_event_search
    participations = Participation.global_search(params[:search])
    participations.joins(:event).where(participations: { user_id: current_user.id })
  end

  def created_events
    Event.where(user_id: current_user.id)
  end

  def search_created_events
    Event.search_by_title_and_description(params[:created_search]).where(user_id: current_user.id)
  end

  def past_events
    events = Event.where('end_date < ?', Date.today)
    events.joins(:participations).where(participations: { user_id: current_user.id }).order(start_date: :asc).limit(5)
  end
end
