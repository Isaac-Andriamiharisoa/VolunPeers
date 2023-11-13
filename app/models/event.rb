class Event < ApplicationRecord
  include PgSearch::Model
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  after_create :create_chatroom
  has_one :chatroom, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_one_attached :photo
  belongs_to :user

  validates :title, :contact, :address, :start_date, :end_date, :start_time, :end_time, presence: true
  validates :description, presence: true, length: { minimum: 150, maximum: 250 }

  pg_search_scope :search_by_title_and_description,
                  against: %i[title description],
                  using: {
                    tsearch: { prefix: true } # <-- now `superman batm` will return something!
                  }

  def create_chatroom
    Chatroom.create name: title, event_id: id
  end
end
