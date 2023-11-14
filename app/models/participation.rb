class Participation < ApplicationRecord
  include PgSearch::Model
  belongs_to :user
  belongs_to :event
  has_many :testimonials, dependent: :destroy
  validates :user_id, uniqueness: { scope: :event_id, message: "You already participated in that event" }

  pg_search_scope :global_search,
                  associated_against: {
                    event: %i[title description]
                  },
                  using: {
                    tsearch: { prefix: true }
                  }
end
