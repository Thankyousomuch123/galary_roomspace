class Photo < ApplicationRecord
  belongs_to :album
  has_one_attached :image # Assuming Active Storage is used
  has_many :shared_photos, dependent: :destroy
  has_many :shared_users, through: :shared_photos, source: :user

  validates :title, presence: true
  validates :image, presence: true
  validate :image_format

  def image_format
    if image.attached?
      # Check for allowed formats
      allowed_formats = ['image/png', 'image/jpg', 'image/jpeg', 'image/gif']
      unless allowed_formats.include?(image.blob.content_type)
        errors.add(:image, 'must be a PNG, JPG, JPEG, or GIF')
      end
    else
      errors.add(:image, 'must be attached')
    end
  end
end