class Video < ApplicationRecord
  belongs_to :album
  has_one_attached :file # Assuming Active Storage is used

  validates :title, presence: true
  validates :file, presence: true
  validate :video_format
  has_many :sharings, as: :shareable

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
