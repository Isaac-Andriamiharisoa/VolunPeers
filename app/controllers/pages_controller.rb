class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @testimonials = Testimonial.all.limit(3).order(created_at: :desc)
  end

  def calendar
    @events = search
  end

  private

  def search
    events = Event.where('title ILIKE ? OR description ILIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
    events.joins(:participations).where(participations: { user_id: current_user.id })
  end
end
