class ImagesController < ApplicationController
  respond_to :json

  def create
    @image = Image.new(image: image_params.first) if image_params.first
    unless @image
      return render json: { error: 'image data not contain' }, status: :unprocessable_entity
    end

    if @image.save
      render :show, status: :created
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end

  private

  def image_params
    params.fetch(:files, {})
  end
end
