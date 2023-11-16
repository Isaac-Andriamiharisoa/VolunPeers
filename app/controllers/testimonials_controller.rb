class TestimonialsController < ApplicationController
  def new
    @testimonial = Testimonial.new
  end

  def create
    @testimonial = Testimonial.new(testimonial_params)
    if @testimonial.save
      redirect_to root_path, notice: "Your testimonial is published"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def testimonial_params
    params.require(:testimonial).permit(:content)
  end

end
