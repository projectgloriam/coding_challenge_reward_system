class ApplicationController < ActionController::Base
    #protect_from_forgery with: :null_session
      # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    helper_method :current_user

    private
        def confirmed_logged_in
            unless session[:user_id]	
                flash[:info] = "Please log in"
                redirect_to login_path
                return false
            else
                return true
            end
        end

        def show_notifications
            #check if user has invites
            userid = session[:user_id]
            @invites = Invite.where(invitee_id: userid, confirm: false)

            if @invites != nil then
            flash[:notice] = "You have " + @invites.count.to_s + " invite(s)."
            end

            rescue ActiveRecord::RecordNotFound
                flash[:alert] = "Invalid Login"
        end
end
