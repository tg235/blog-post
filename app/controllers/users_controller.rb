class UsersController < ApplicationController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :show_home_page
  before_action :set_user

  def show; end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def show_home_page
    redirect_to root_path
  end
end
