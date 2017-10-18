class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]

    check_valid @user
    current_user.follow @user
    respond_to_user
  end

  def destroy
    relationship = Relationship.find_by id: params[:id]

    check_valid relationship
    @user = relationship.followed
    current_user.unfollow @user
    respond_to_user
  end

  private

  def respond_to_user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def check_valid object
    return if object
    flash[:danger] = t "not_found"
    redirect_to current_user
  end
end
