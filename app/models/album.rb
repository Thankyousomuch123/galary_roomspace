class Album < ApplicationRecord
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :videos, dependent: :destroy

  validates :album_type, inclusion: { in: ['photo', 'video'] }

  validates :name, presence: true
  has_one_attached :avatar
  validate :avatar_validation

  scope :photo_albums, -> { where(album_type: 'photo') }
  scope :video_albums, -> { where(album_type: 'video') }

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
