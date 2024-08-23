class AlbumsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_album, only: %i[ show edit update destroy share purge_avatar update_share]

  def index
    @albums = current_user.albums.order(created_at: :desc)
  end

  def purge_avatar
    @album.avatar.purge
    redirect_back fallback_location: root_path, notice: "success"
  end

  def show
  end

  def new
    @album = current_user.albums.new
  end

  def create
    @album = current_user.albums.new(album_params)
    if @album.save
      redirect_to @album
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @album.update(album_params)
      redirect_to @album, notice: 'Album was successfully updated.'
    else
      render :edit
    end
  end

  def share
    @users = User.where.not(id: current_user.id)
  end

  def update_share
    user_ids = params[:shared_user_ids] || []
    @album.shared_albums.where.not(user_id: user_ids).destroy_all
    user_ids.each do |user_id|
      SharedAlbum.find_or_create_by(album: @album, user_id: user_id)
    end
    redirect_to @album
  end

  private

  def set_album
	  @album = current_user.albums.find(params[:id])
	end

  def album_params
    params.require(:album).permit(:name, :avatar)
  end
end
