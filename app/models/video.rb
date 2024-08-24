class Video < ApplicationRecord
  belongs_to :album
  has_one_attached :file # Assuming Active Storage is used
  has_many :shared_videos, dependent: :destroy
  has_many :shared_users, through: :shared_videos, source: :user

  validates :title, presence: true
  validates :file, presence: true
  validate :video_format

  def video_format
    if file.attached?
      allowed_formats = ['video/mp4', 'video/mpeg', 'video/quicktime', 'video/x-msvideo']
      unless allowed_formats.include?(file.blob.content_type)
        errors.add(:file, 'must be an MP4, MPEG, QuickTime, or AVI file')
      end
    else
      errors.add(:file, 'must be attached')
    end
  end
end
