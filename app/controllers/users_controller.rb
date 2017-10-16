class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t "users.success_welcome"
      log_in @user
      redirect_to @user
    else
      flash.now[:danger] = t "users.signup_error"
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t "users.not_exist"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation
  end
end
