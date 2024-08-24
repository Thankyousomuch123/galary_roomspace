class VideosController < ApplicationController
  before_action :set_album
  before_action :set_video, only: %i[show edit update destroy share]
  before_action :authenticate_user!
  before_action :authorize_user!, only: %i[destroy]

  def new
    # Ensure that only video albums can have videos
    if @album.album_type == 'video'
      @video = @album.videos.new
    else
      redirect_to album_path(@album), alert: 'You cannot add videos to a photo album.'
    end
  end

  def create
    # Ensure that only video albums can have videos
    if @album.album_type == 'video'
      @video = @album.videos.new(video_params)
      if @video.save
        redirect_to @album
      else
        render :new
      end
    else
      redirect_to album_path(@album), alert: 'You cannot add videos to a photo album.'
    end
  end

  def show
  end

  def share
    @video = Video.find(params[:id])
    users = User.where(id: params[:user_ids])

    # Track the success of each Sharing record creation
    all_saved = true

    users.each do |user|
      sharing = Sharing.create(shareable: @video, user: user, shared_at: Time.current, shared_user_id: current_user.id)
      unless sharing.persisted?  # Check if the record was saved successfully
        all_saved = false
        # Optionally, handle the specific errors if needed
      end
    end

    if all_saved
      render json: { message: 'Video shared successfully' }, status: :ok
    else
      render json: { error: 'Failed to share Video' }, status: :unprocessable_entity
    end
  end


  def destroy
    if @video.destroy
      redirect_to album_path(@album), notice: 'Video was successfully deleted.'
    else
      redirect_to album_path(@album), alert: 'Failed to delete the video.'
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :file) # Ensure this matches the video model's attributes
  end

  def set_album
    @album = current_user.albums.find(params[:album_id])
  end

  def set_video
    @video = @album.videos.find(params[:id])
  end

  def authorize_user!
    unless @video.album.user == current_user
      redirect_to album_path(@album), alert: 'You are not authorized to delete this video.'
    end
  end
end
