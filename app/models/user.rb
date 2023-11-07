class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :photo
  has_many :participations, dependent: :destroy

  def upload_image_to_cloudinary
    raise
    Cloudinary::Uploader.upload(photo.path, public_id: username)
  end
end
