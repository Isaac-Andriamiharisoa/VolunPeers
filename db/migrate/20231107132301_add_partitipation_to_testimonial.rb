class AddPartitipationToTestimonial < ActiveRecord::Migration[7.1]
  def change
    add_reference :testimonials, :participation, null: false, foreign_key: true
  end
end
