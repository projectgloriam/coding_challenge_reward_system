class WelcomeController < ApplicationController
  before_action :confirmed_logged_in, only: [:index]
  before_action :show_notifications, only: [:index]

  def index
  end

  def login
    if current_user then
			redirect_to root_path
		else
			flash[:info] = "Please login" if flash[:info].blank?
		end

    @users = User.all
  end

  def auth
      user_id = params[:user_id]
      fetch_user = User.find(user_id)

		  if fetch_user != nil then
        	session[:user_id] = fetch_user.id
          session[:user_name] = fetch_user.name
        	flash[:success] = "Welcome #{session[:user_name]}"
        	redirect_to welcome_path
        	# redirect_to root_path
    	end

      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Invalid Login"
        redirect_to login_path
	end

  def logout
		#cancel every session before logout incase they don't end
		session[:user_id] = nil
    session[:user_name] = nil
		flash[:info] = "You are now logged out"
		redirect_to login_path
	end
end
