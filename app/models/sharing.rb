class Sharing < ApplicationRecord
  belongs_to :shareable, polymorphic: true
  belongs_to :user

  validates :shared_at, presence: true
end
