class PhotosController < ApplicationController
  before_action :set_album
  before_action :set_photo, only: %i[show edit update destroy share update_share]
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
    # Ensure that sharing functionality is appropriate for photos
    @users = User.where.not(id: current_user.id)
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
