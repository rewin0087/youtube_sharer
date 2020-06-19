class PostsController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]

  def index
    @post = Post.new(user: current_user)
    @posts = Post.page(params[:page])
  end

  def create
    @post = Post.new(post_params)

    if @post.valid? && @post.save
      @posts = Post.page(params[:page])
    end
  end

  private

    def post_params
      params.require(:post).permit(:youtube_url, :user_id, :title, :description)
    end
end
