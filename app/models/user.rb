class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :albums, dependent: :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :sharings
  has_many :shared_photos, through: :sharings, source: :shareable, source_type: 'Photo'
  has_many :shared_videos, through: :sharings, source: :shareable, source_type: 'Video'
  has_many :shared_albums, through: :sharings, source: :shareable, source_type: 'Album'       

  def self.from_omniauth(auth)
    # Extract the domain from the email
    email = auth.info.email
    domain = email.split('@').last

    # Define the allowed domain
    allowed_domain = 'gmail.com'

    # Check if the email's domain matches the allowed domain
    return nil unless domain == allowed_domain

    # Find or create the user based on provider and UID
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name
      user.avatar_url = auth.info.image
    end
  end
end
