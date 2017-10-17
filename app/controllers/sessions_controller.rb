class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me].to_i == 1 ?
          remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = t "sessions.not_activated"
        redirect_to root_path
      end
    else
      flash.now[:danger] = t "sessions.login_failed"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
