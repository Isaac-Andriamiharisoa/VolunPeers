class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @testimonials = Testimonial.all.limit(3).order(created_at: :desc)
    @event = Event.all.order(start_date: :asc).limit(1)
    @user = User.first
  end

  def calendar
    @events = search_calendar
  end

  def dashboard
    @events = search_calendar
    @events_count = Event.all.joins(:participations).where(participations: { user_id: current_user.id }).count
    @past_events = past_events
  end

  private

  def search_calendar
    events = Event.where('title ILIKE ? OR description ILIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
    events.joins(:participations).where(participations: { user_id: current_user.id }).order(start_date: :asc)
  end

  def past_events
    events = Event.where('end_date < ?', Date.today)
    events.joins(:participations).where(participations: { user_id: current_user.id }).order(start_date: :asc)
  end
end
