class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :user_signed_in?

  def user_signed_in?
    !current_user.nil?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :avatar, :email, :password, :password_confirmation])
  end

  def after_sign_up_path_for(resource)
    redirect_to root_path
  end

  def after_sign_in_path_for(resource)
    root_path
  end
end
