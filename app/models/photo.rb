class Photo < ApplicationRecord
  belongs_to :album
  has_one_attached :image # Assuming Active Storage is used
  has_many :shared_photos, dependent: :destroy
  has_many :shared_users, through: :shared_photos, source: :user
end
