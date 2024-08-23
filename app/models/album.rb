class Album < ApplicationRecord
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :shared_albums, dependent: :destroy
  has_many :shared_users, through: :shared_albums, source: :user

  validates :name, presence: true
  has_one_attached :avatar
  validate :avatar_validation

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

  def to_s
    name
  end
end
