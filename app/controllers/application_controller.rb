class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
  	@user ||= User.find(session[:user_id])
  end
  #makes current_user a helper method, which makes it accessible in views
  helper_method :current_user

end
