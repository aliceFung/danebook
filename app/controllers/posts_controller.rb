class PostsController < ApplicationController

  before_action :require_valid_user
  before_action :require_current_user, :except => [:index]

  # timeline
  def index
    @post = Post.new

    @user = User.includes(:profile, :friended_users,
                :posts => [:likes, :comments],
                :comments => [:likes, :user]).find(params[:user_id])
    @posts = @user.posts.order("created_at DESC")

    @photos = @user.photos
    @profile = @user.profile

    respond_to do |format|
      format.html
      format.js {}
    end
  end

  def create
    @post = Post.new(params_list)
    @post.user_id = current_user.id
    if @post.save
      flash[:success] = "You created a post"
    else
      flash[:error] = "There was an error creating your post."
    end

    respond_to do |format|
        format.html { redirect_to user_posts_path(current_user) }
        format.js { render template: 'shared/flash_display' }
    end
  end

  def destroy
    @post = Post.find(params[:id])
    # @thing = @post
    respond_to do |format|
      if (current_user.id == @post.user_id) && @post.destroy
        flash[:success] = "Your post has been deleted!"
        format.html {redirect_to user_posts_path(current_user)}
        format.js {render template: "shared/destroy_success",
                            locals: {thing: @post}}
      else
        flash[:error] = "There was an error deleting your post."
        format.html {redirect_to user_posts_path(current_user)}
        format.js { render template: 'shared/flash_display'  }
      end
    end
  end

  private

  def params_list
      params.require(:post).permit(:title, :body, :id, :user_id )
  end
end
