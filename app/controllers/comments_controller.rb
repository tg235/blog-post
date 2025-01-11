class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_blog_post
  before_action :find_comment, except: [:new, :create, :index]
  def index
    @comments = @blog_post.comments
  end

  def new
    @comment = @blog_post.comments.new
  end

  def create
    @comment = @blog_post.comments.new(comment_params.merge(user_id: current_user&.id))
    message = @comment.save ? 'Comment added successfully' : 'Empty comment not allowed'
    redirect_to @blog_post, notice: message
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to @comment.blog_post, notice: 'Comment updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to @comment.blog_post, notice: 'Comment deleted'
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def find_blog_post
    @blog_post = BlogPost.find(params[:blog_post_id])
  end

  def find_comment
    @comment = @blog_post.comments.find(params[:id])
  end
end
