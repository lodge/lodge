# encoding: utf-8
class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :check_permission, only: [:edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article
      .includes(:user, :stocks, :tags)
      .page(params[:page]).per(PER_SIZE)
  end

  # GET /articles
  # GET /articles.json
  def feed
    following_tags = FollowingTag.includes(:tag).where(user_id: current_user.id)
    following_tag_names = following_tags.map {|f| f.tag.name } unless following_tags.nil?
    @articles = Article
      .includes(:user, :stocks, :tags)
      .page(params[:page]).per(PER_SIZE)
      .tagged_with(following_tag_names, any: true)
    render :index
  end

  # GET /articles
  # GET /articles.json
  def search
    query = "%#{params[:query].gsub(/([%_])/){"\\" + $1}}%"
    @articles = Article.where("title like ?", query)
        .page(params[:page]).per(PER_SIZE)
    render :index
  end

  # GET /articles/stocks
  # GET /articles/stocks.json
  def by_stocks
    @articles = current_user.stocked_articles.includes(:tags, :stocks, :user).page(params[:page]).per(PER_SIZE)
    render :index
  end

  # GET /articles/tag/1
  # GET /articles/tag/1.json
  def by_user
    @articles = current_user.articles.includes(:tags, :stocks).page(params[:page]).per(PER_SIZE)
    render :index
  end

  # GET /articles/tag/1
  # GET /articles/tag/1.json
  def by_tag
    @articles = Article.includes(:tags, :stocks, :user).page(params[:page]).per(PER_SIZE).tagged_with(params[:tag_name])
    @tag = Tag.find_by_name(params[:tag_name])
    render :index
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
    respond_to do |format|
      response_html = ArticlesController.helpers.markdown(params[:body], false)
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
    @article.tag_list = params[:article][:tags]

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
    @article.old_title = @article.title
    @article.old_body = @article.body
    @article.old_tags = @article.tag_list.join(",")
    @article.tag_list = params[:article][:tags]
    @article.new_tags = @article.tag_list.join(",")
    @article.update_user_id = current_user.id
    attributes = article_params
    attributes.delete(:user_id)
    respond_to do |format|
      if @article.update(attributes)
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.includes({:comments => :user}, :stocks).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def article_params
    if @article and @article.user_id == current_user.id
      params.require(:article).permit(:user_id, :title, :body, :lock_version, :is_public_editable)
    else
      params.require(:article).permit(:user_id, :title, :body, :lock_version)
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def check_permission
    return if @article.user_id == current_user.id || @article.is_public_editable
    redirect_to articles_url
  end
end
