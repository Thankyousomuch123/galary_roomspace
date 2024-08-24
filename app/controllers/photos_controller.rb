class PhotosController < ApplicationController
  before_action :set_album
  before_action :set_photo, only: %i[show edit update destroy share]
  before_action :authenticate_user!
  before_action :authorize_user!, only: %i[destroy]

  def new
    # Ensure that only photo albums can have photos
    if @album.album_type == 'photo'
      @photo = @album.photos.new
    else
      redirect_to album_path(@album), alert: 'You cannot add photos to a video album.'
    end
  end

  def create
    # Ensure that only photo albums can have photos
    if @album.album_type == 'photo'
      @photo = @album.photos.new(photo_params)
      if @photo.save
        redirect_to @album
      else
        render :new
      end
    else
      redirect_to album_path(@album), alert: 'You cannot add photos to a video album.'
    end
  end

  def show
  end

  def share
    @photo = Photo.find(params[:id])
    users = User.where(id: params[:user_ids])

    # Track the success of each Sharing record creation
    all_saved = true

    users.each do |user|
      sharing = Sharing.create(shareable: @photo, user: user, shared_at: Time.current, shared_user_id: current_user.id)
      unless sharing.persisted?  # Check if the record was saved successfully
        all_saved = false
        # Optionally, handle the specific errors if needed
      end
    end

    if all_saved
      render json: { message: 'Photo shared successfully' }, status: :ok
    else
      render json: { error: 'Failed to share Photo' }, status: :unprocessable_entity
    end
  end


  def destroy
    if @photo.destroy
      redirect_to album_path(@album), notice: 'Photo was successfully deleted.'
    else
      redirect_to album_path(@album), alert: 'Failed to delete the photo.'
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:title, :image) # Ensure this matches the photo model's attributes
  end

  def set_album
    @album = current_user.albums.find(params[:album_id])
  end

  def set_photo
    @photo = @album.photos.find(params[:id])
  end

  def authorize_user!
    unless @photo.album.user == current_user
      redirect_to album_path(@album), alert: 'You are not authorized to delete this photo.'
    end
  end
end
