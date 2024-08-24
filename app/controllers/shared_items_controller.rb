class SharedItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Fetch shared items for the current user
    @shared_photos = current_user.shared_photos.includes(:sharings)
    @shared_videos = current_user.shared_videos.includes(:sharings)
    @shared_albums = current_user.shared_albums.includes(:sharings)
  end
end
