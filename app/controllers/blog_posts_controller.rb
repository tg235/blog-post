class BlogPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_blog_post, only: [:edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :render_posts

  def index
    @blog_posts = BlogPost.where.not(publication_date: nil).paginate(page: params[:page], per_page: 10)
  end

  def show
    @blog_post = BlogPost.find(params[:id])
    @comment = Comment.new
  end

  def new
    @blog_post = current_user.blog_posts.new
  end

  def create
    @blog_post = current_user.blog_posts.new(blog_post_params)
    @blog_post.publication_date = Time.zone.now if published?

    if @blog_post.save
      flash[:notice] = "Post created successfully"
      redirect_to @blog_post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @blog_post.publication_date = published? ? Time.zone.now : nil 
    if @blog_post.update(blog_post_params)
      redirect_to @blog_post, notice: 'Post updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog_post.destroy
    redirect_to blog_posts_url, notice: 'Post deleted successfully'
  end

  def view_drafts
    @blog_posts = current_user.blog_posts&.where(publication_date: nil).paginate(page: params[:page], per_page: 10)
  end

  private

  def blog_post_params
    params.require(:blog_post).permit(:title, :content, :publication_date, :published)
  end

  def find_blog_post
    @blog_post = current_user.blog_posts.find(params[:id])
  end

  def render_posts
    redirect_to blog_posts_url
  end

  def published?
    params[:commit] == "Publish"
  end
end
