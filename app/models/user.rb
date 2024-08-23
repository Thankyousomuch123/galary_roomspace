class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    # Extract the domain from the email
    email = auth.info.email
    domain = email.split('@').last

    # Define the allowed domain
    allowed_domain = 'elitmus.com'

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
