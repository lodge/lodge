# encoding: utf-8
class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy, :stock, :unstock]
  before_action :check_permission, only: [:edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article
      .includes(:user, :stocks, :tags)
      .page(params[:page]).per(PER_SIZE)
      .order(:updated_at => :desc)
  end

  # GET /articles
  # GET /articles.json
  def feed
    @articles = Article
      .includes(:user, :stocks, :tags)
      .page(params[:page]).per(PER_SIZE)
      .tagged_with(current_user.following_tag_list, any: true)
      .order(:updated_at => :desc)
  end

  # GET /articles
  # GET /articles.json
  def search
    query = "%#{params[:query].gsub(/([%_])/){"\\" + $1}}%"
    @articles = Article.where("title like ?", query)
        .page(params[:page]).per(PER_SIZE).order(:updated_at => :desc)
  end

  # GET /articles/stocks
  # GET /articles/stocks.json
  def stocked
    @articles = current_user.stocked_articles.includes(:tags, :stocks, :user).page(params[:page]).per(PER_SIZE).order(:updated_at => :desc)
  end

  # GET /articles/tag/1
  # GET /articles/tag/1.json
  def owned
    @articles = current_user.articles.includes(:tags, :stocks).page(params[:page]).per(PER_SIZE).order(:updated_at => :desc)
  end

  # GET /articles/tag/1
  # GET /articles/tag/1.json
  def tagged
    @articles = Article.includes(:stocks, :user).page(params[:page]).per(PER_SIZE).tagged_with(params[:tag]).order(:updated_at => :desc)
    @tag = params[:tag]
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @stock = Stock.find_by(:article_id => @article.id, :user_id => current_user.id)
    @stocked_users = @article.stocked_users
    @article.remove_user_notification(current_user)
  end

  # POST /articles/preview
  def preview
    preview = MarkdownPreview.new(preview_params)
    respond_to do |format|
      format.js { render text: preview.body_html }
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
    params.require(:article).permit(:user_id, :title, :body, :tag_list, :lock_version)
  end

  def preview_params
    params.require(:preview).permit(:body)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def check_permission
    return if @article.user_id == current_user.id
    redirect_to articles_url
  end
end
