class Testimonial < ApplicationRecord
  belongs_to :participation
  delegate :user, to: :participation
end
