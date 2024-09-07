class ArticlesController < ApplicationController
  protect_from_forgery with: :null_session, only: [ :create ] # Be cautious with this in production!

  def index
    @page = params[:page].to_i || 1
    @per_page = 4
    @total_articles = Article.count
    @total_pages = (@total_articles.to_f / @per_page).ceil
    @articles = Article.order(created_at: :desc).offset((@page - 1) * @per_page).limit(@per_page)
  end


  def show
    @article = Article.find(params[:id])
    @article.increment!(:views)
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
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to article_path(@article)
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end

  private
  def article_params
    params.require(:article).permit(:title, :body)
  end
end
