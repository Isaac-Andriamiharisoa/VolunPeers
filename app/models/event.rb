class Event < ApplicationRecord
  belongs_to :user
  has_many :participations, dependent: :destroy
  has_many :users, through: :participations
  after_create :create_chatroom
  has_one :chatroom, dependent: :destroy
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  has_one_attached :photo

  def create_chatroom
    Chatroom.create name: title, event_id: id
  end
end
