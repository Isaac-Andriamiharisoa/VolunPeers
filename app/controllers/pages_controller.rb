class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    # @testimonials = Testimonial.all.limit(3).order(created_at: :desc)
    @testimonials = Testimonial.includes(:participation).all.limit(3)
    @event = Event.where('start_date > ?', DateTime.now).order(start_date: :asc).first
    @actual_time = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
    @user = User.first
    @volunteers_count = User.count
    @events_count = Event.count
    @hoster_count = Event.select(:user_id).distinct.count
  end

  def calendar
    if params[:search].present? && params[:search] != ""
      @participations = participated_event_search
    else
      @participations = global_events
    end
  end

  def about
  end

  def participants
    @event = Event.find(params[:event_id])
    @participants = @event.users
  end

  def dashboard
    @tree_quantity = Event.where(action: "Trees to Plant", user_id: current_user.id).where("end_date < ?",
                                                                                           DateTime.now).sum(:quantity)
    @people_quantity = Event.where(action: "Peoples to Help", user_id: current_user.id).sum(:quantity)
    @batiment_quantity = Event.where(action: "Batiment to Build", user_id: current_user.id).sum(:quantity)
    @animal_quantity = Event.where(action: "Animal to save", user_id: current_user.id).sum(:quantity)
    @litter_quantity = Event.where(action: "Litter to Clean", user_id: current_user.id).sum(:quantity)

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
