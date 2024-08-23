class PhotosController < ApplicationController

  before_action :set_album
  before_action :set_photo, only: [:show, :edit, :update, :destroy, :share, :update_share]
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:destroy]

  def new
    @photo = @album.photos.new
  end

  def create
    @photo = @album.photos.new(photo_params)
    if @photo.save
      redirect_to @album
    else
      render :new
    end
  end

  def show
  end

  def share
    @photo = @album.photos.find(params[:id])
    @users = User.where.not(id: current_user.id)
  end

  def update_share
    @photo = @album.photos.find(params[:id])
    user_ids = params[:shared_user_ids] || []
    @photo.shared_photos.where.not(user_id: user_ids).destroy_all
    user_ids.each do |user_id|
      SharedPhoto.find_or_create_by(photo: @photo, user_id: user_id)
    end
    redirect_to album_path(@album)
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
    params.require(:photo).permit(:title, :image)
  end

  def set_album
    @album = current_user.albums.find(params[:album_id])
  end

  def set_photo
    @photo = @album.photos.find(params[:id])
  end

  def authorize_user!
    unless @photo.album.user == current_user
      redirect_to album_path(@album), alert: "You are not authorized to delete this photo."
    end
  end
end
