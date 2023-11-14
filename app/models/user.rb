class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :photo
  has_many :participations, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :chatrooms, through: :events

  validates :role, inclusion: { in: %w[normal owner admin] }

  enum role: %i[normal owner admin]
  after_initialize :set_default_role, if: :new_record?
  # set default role to user  if not set
  def set_default_role
    self.role ||= :user
  end

  def participated_chatrooms
    participations.map { |p| p.event.chatroom }
  end
end
