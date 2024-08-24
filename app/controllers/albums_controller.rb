class AlbumsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_album, only: %i[ show edit update destroy purge_avatar share]

  def index
    @albums = current_user.albums.order(created_at: :desc)
  end

  def purge_avatar
    @album.avatar.purge
    redirect_back fallback_location: root_path, notice: "success"
  end

  def show
    @users = User.all
  end

  def new
    @album = current_user.albums.new(album_type: params[:album_type])
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
    @album = Album.find(params[:id])
    users = User.where(id: params[:user_ids])

    # Track the success of each Sharing record creation
    all_saved = true

    users.each do |user|
      sharing = Sharing.create(shareable: @album, user: user, shared_at: Time.current, shared_user_id: current_user.id)
      unless sharing.persisted?  # Check if the record was saved successfully
        all_saved = false
        # Optionally, handle the specific errors if needed
      end
    end

    if all_saved
      render json: { message: 'Album shared successfully' }, status: :ok
    else
      render json: { error: 'Failed to share Album' }, status: :unprocessable_entity
    end
  end

  private

  def set_album
    @album = current_user.albums.find(params[:id])
  end

  def album_params
    params.require(:album).permit(:name, :avatar, :album_type)
  end
end
