class Event < ApplicationRecord
  belongs_to :user
  has_many :participations, dependent: :destroy
  after_create :create_chatroom
  has_one :chatroom, dependent: :destroy

  def create_chatroom
    Chatroom.create name: title, event_id: id
  end
end
