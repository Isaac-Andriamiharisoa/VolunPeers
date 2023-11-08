class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_many :testimonials, dependent: :destroy
  validates :user_id, uniqueness: { scope: :event_id, message: "You already participated in that event" }
end
