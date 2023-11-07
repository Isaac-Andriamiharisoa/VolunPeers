class Event < ApplicationRecord
  has_many :participations,  dependent: :destroy
end
