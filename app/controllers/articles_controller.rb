class ArticlesController < ApplicationController
  protect_from_forgery with: :null_session, only: [ :create, :update, :destroy ]
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]

  http_basic_authenticate_with name: "admin", password: "admin", except: [ :index, :show ]

  def index
    @page = params[:page].to_i.positive? ? params[:page].to_i : 1
    @per_page = params[:limit].to_i.positive? ? params[:limit].to_i : 10
    @total_articles = Article.count
    @total_pages = (@total_articles.to_f / @per_page).ceil
    @articles = Article.order(created_at: :desc).offset((@page - 1) * @per_page).limit(@per_page)

    respond_to do |format|
      format.html
      format.json {
        render json: {
          articles: @articles,
          meta: {
            current_page: @page,
            per_page: @per_page,
            total_pages: @total_pages,
            total_articles: @total_articles
          }
        }
      }
    end
  end

  def show
    @article.increment!(:views)
    respond_to do |format|
      format.html
      format.json { render json: @article }
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "Article was successfully created." }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render json: @article, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :body, :status)
  end
end
