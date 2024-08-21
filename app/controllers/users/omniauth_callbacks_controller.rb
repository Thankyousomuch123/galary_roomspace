class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # Extract the user's email and domain
    email = auth.info.email
    domain = email.split('@').last

    # Define the allowed domain
    allowed_domain = 'elitmus.com'

    # Check if the user is from the allowed domain
    if domain == allowed_domain
      user = User.from_omniauth(auth)

      if user.present?
        sign_out_all_scopes
        flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect user, event: :authentication
      else
        flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{email} is not authorized."
        redirect_to new_user_session_path
      end
    else
      # If the user's domain is not allowed, show an error message and redirect
      flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{email} is not authorized."
      redirect_to new_user_session_path
    end
  end

  protected

  def after_omniauth_failure_path_for(_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  private

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
