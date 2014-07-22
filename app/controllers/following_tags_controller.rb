class FollowingTagsController < ApplicationController
  before_action :check_permission, only: [:destroy]
  before_action :following_tag_params, only: [:create, :destroy]

  # POST /articles
  # POST /articles.json
  def create
    current_user.following_tag_list << following_tag_params[:tag]
    respond_to do |format|
      if current_user.save
        format.html { redirect_to :back, notice: 'Tag was successfully followed.' }
        format.json { render :show, status: :created, location: @following_tag }
      else
        format.html { redirect_to :back, error: 'Tag was failure followed.' }
        format.json { render json: @following_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    current_user.following_tag_list.remove(following_tag_params[:tag])
    current_user.save
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Tag was successfully unfollowed.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def following_tag_params
    params.permit(:tag)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def check_permission
    return if current_user.follow? following_tag_params[:tag]
    redirect_to articles_url
  end
end
