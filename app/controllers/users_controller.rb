class UsersController < ApplicationController
  before_action :authenticate_user! # Ensure only logged-in users can access this page

  def index
    @users = User.all
  end
end
