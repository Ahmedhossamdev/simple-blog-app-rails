class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to article_path(@article), notice: "Comment was successfully created." }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend(:comments, partial: "comments/comment", locals: { comment: @comment }),
            turbo_stream.update("comment-count", @article.comments.count),
            turbo_stream.update("comment-form", partial: "comments/form", locals: { article: @article })
          ]
        end
      else
        format.html { render "articles/show", status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(:comment_form, partial: "comments/form", locals: { article: @article, comment: @comment })
        }
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:commenter, :body, :status)
  end
end
