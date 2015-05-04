# encoding: utf-8
class ArticlesController < ApplicationController
  before_action :set_article, only: [
    :show, :edit, :update, :destroy, :stock, :unstock
  ]
  before_action :check_update_permission, only: [:edit, :update]
  before_action :check_destroy_permission, only: [:destroy]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.recent_list(params[:page])
  end

  # GET /articles
  # GET /articles.json
  def feed
    @articles = Article.feed_list(current_user, params[:page])
  end

  # GET /articles
  # GET /articles.json
  def search
    @articles = Article.search(params[:query], params[:page])
  end

  # GET /articles/stocks
  # GET /articles/stocks.json
  def stocked
    @articles = Article.stocked_by(current_user, params[:page])
  end

  # GET /articles/tag/1
  # GET /articles/tag/1.json
  def owned
    @articles = Article.owned_by(current_user, params[:page])
  end

  # GET /articles/tag/1
  # GET /articles/tag/1.json
  def tagged
    @articles = Article.tagged_by(params[:tag], params[:page])
    @tag = params[:tag]
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @stock = Stock.find_by(article_id: @article.id, user_id: current_user.id)
    @stocked_users = @article.stocked_users
    @article.remove_user_notification(current_user)
  end

  # POST /articles/preview
  def preview
    respond_to do |format|
      response_html = ArticlesController.helpers.markdown(params[:body])
      format.js { render text: response_html }
    end
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      @article.update_user_id = current_user.id
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end

  def stock
    current_user.stock(@article)
  end

  def unstock
    current_user.unstock(@article)
    render :stock
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.includes({:comments => :user}).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def article_params
    params.require(:article).permit(:user_id, :title, :body, :tag_list, :lock_version, :is_public_editable)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def check_update_permission
    return if owner? || @article.is_public_editable
    redirect_to articles_url
  end

  def check_destroy_permission
    return if owner?
    redirect_to articles_url
  end

  def owner?
    @article.user_id == current_user.id
  end
end
