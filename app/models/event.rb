class Event < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  after_create :create_chatroom
  has_one :chatroom, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_one_attached :photo
  belongs_to :user

  def create_chatroom
    Chatroom.create name: title, event_id: id
  end

end
