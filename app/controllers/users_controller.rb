class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :load_user,
    only: [:show, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :verify_admin!, only: :destroy

  def index
    @users = User.user_info.activated_user.paginate page: params[:page],
      per_page: Settings.user_model.page_size
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t "mailer.activation.inform"
      redirect_to root_url
    else
      flash.now[:danger] = t "users.signup_error"
      render :new
    end
  end

  def show
    @microposts = @user.microposts.paginate page: params[:page],
      per_page: Settings.micropost_model.page_size
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "users.update_success"
      redirect_to @user
    else
      flash.now[:danger] = t "users.update_failed"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.delete_success"
    else
      flash[:danger] = t "users.delete_failed"
    end
    redirect_to users_path
  end

  def following
    @title = t "users.following"
    @users = @user.following.paginate page: params[:page],
      per_page: Settings.user_model.page_size
    render "show_follow"
  end

  def followers
    @title = t "users.follower"
    @users = @user.followers.paginate page: params[:page],
      per_page: Settings.user_model.page_size
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]

    return if @user && @user.activated?
    flash[:danger] = t "users.not_exist"
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "users.loggin_require"
    redirect_to login_path
  end

  def correct_user
    redirect_to root_url unless @user.is_user? current_user
  end

  def verify_admin!
    return if current_user.is_admin?

    flash[:danger] = t "users.delete_warn"
    redirect_to root_url
  end
end
