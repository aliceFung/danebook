class PostsController < ApplicationController

  before_action :require_valid_user
  before_action :require_current_user, :except => [:index]

  def index
    # @posts = Post.where("user_id = ?", params[:user_id]).
    #               includes(:likes, :comments => [:likes, :user])
    @post = Post.new

    @user = User.includes(:profile, :friended_users, :posts => [:likes, :comments], :comments => [:likes, :user]).find(params[:user_id])
    @posts = @user.posts.order("created_at DESC")
    # currently doubling as timeline,
    # may separate to timeline controller
    # @user = User.find(params[:user_id])
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
    respond_to do |format|
      if @post.save
        flash[:success] = "You created a post"
        format.html { redirect_to user_posts_path(current_user) }
        format.js
      else
        flash[:error] = "There was an error creating your post."
        format.html { render :index }

        # render empty template
        format.js { head :none }
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if (current_user.id == @post.user_id) && @post.destroy
      flash[:success] = "Your post has been deleted!"
      redirect_to user_posts_path(current_user)
    else
      flash[:error] = "There was an error deleting your post, try again."
      redirect_to user_posts_path(current_user)
    end
  end

  private

  def params_list
      params.require(:post).permit(:title, :body, :id, :user_id )
  end
end
