class Post < ApplicationRecord
  validates :title, presence: true

  has_one_attached :avatar
  has_many_attached :images

  validate :avatar_validation
  validate :images_validation

  def avatar_validation
    if avatar.attached?
      if !avatar.content_type.in?(%('image/png image/jpg image/jpeg'))
        errors.add(:avatar, 'must be a PNG, JPG, or JPEG')
      elsif avatar.byte_size > 100.kilobytes
        errors.add(:avatar, 'is too big')
      end
    else
      errors.add(:avatar, 'must be attached')
    end
  end

  def images_validation
    if images.attached?
      if images.size < 1 || images.size > 3
        errors.add(:images, 'must be between 1 and 3 images')
      elsif images.any? { |img| !img.content_type.in?(%('image/png image/jpg image/jpeg audio/mp3')) }
        errors.add(:images, 'must be PNG, JPG, JPEG, or MP3')
      end
    else
      errors.add(:images, 'must be attached')
    end
  end

  def to_s
    title
  end
end
