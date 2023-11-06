class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @testimonials = Testimonial.all.limit(3).order(created_at: :desc)
  end
end
