class Event < ApplicationRecord
  belongs_to :user
  has_many :participations, dependent: :destroy
end
