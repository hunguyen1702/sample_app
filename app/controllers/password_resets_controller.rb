class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
    only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_reset.email_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t "password_reset.not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      flash.now[:danger] = t "password_reset.failed"
      @user.errors.add :password, t("password_reset.empty")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t "password_reset.success"
      redirect_to @user
    else
      flash.now[:danger] = t "password_reset.failed"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]

    return if @user
    flash[:danger] = t "users.not_exist"
    redirect_to root_path
  end

  def valid_user
    return if @user && @user.activated? &&
      @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t "password_reset.expired"
      redirect_to new_password_reset_url
    end
  end
end
