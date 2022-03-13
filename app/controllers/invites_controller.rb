class InvitesController < ApplicationController
	before_action :confirmed_logged_in
	before_action :set_invite, only: [:show]
	before_action :invite_exist, only: [:create]
	before_action :already_invited, only: [:update]

	# GET /invites
  	# GET /invites.json
  	def index
		@invites = Invite.all
	end

	# GET /invites/1
	# GET /invites/1.json
	def show
		@invitee = User.find(@invite.invitee_id)
	end

	# POST /invites
  	# POST /invites.json
	def create
		#@invite = Invite.new(invite_params)

		@invite = Invite.new({:user_id => session[:user_id], :invitee_id => @invitee_id, :confirm => false})

		if @invite.save
			redirect_to users_path, notice: 'Invite was sent successfully.'
		else
			redirect_to users_path, notice: 'Sorry, an error occurred. Please try again.'
		end
	end

	# PATCH/PUT /invites/1
	# PATCH/PUT /invites/1.json
	def update
		invite_id = params[:id]

		@invite = Invite.find(invite_id)

		if @invite.update({:confirm => true})
			#Reward Inviter: 1
			reward_inviter(@invite.user_id)

			#Reward Inviter's inviter
			inviter_level_3 = reward_other_inviters(@invite.user_id, 0.5)

			#Reward Inviter's inviter's inviter
			if inviter_level_3 != nil then
				finished = reward_other_inviters(inviter_level_3, 0.25)
			end

			#confirm all invitations
			user_invites = Invite.where 
			Invite.where(invitee_id: session[:user_id], confirm: false).find_each do |invite|
				invite.confirm = true
				invite.save
			end

			redirect_to users_path, notice: 'You\'ve accepted the invite.'
		else
			redirect_to users_path, notice: 'Sorry, an error occurred. Please try again.'
		end
	end

	private
	def invite_params
		params.require(:invite).permit(:id, :user, :invitee, :confirm)
	end

	# Use callbacks to share common setup or constraints between actions.
	def set_invite
		@invite = Invite.find(params[:id])
	end

	def invite_exist
		@invitee_id = params[:invitee_id]

		#check if user has already invited invitee
		invite_exists = Invite.find_by user_id: session[:user_id], invitee_id: @invitee_id

		@invitee = User.find(@invitee_id)

		if invite_exists != nil
			flash[:alert] = "You've already invited #{@invitee.name}"
        	redirect_to users_path
		end
		
		rescue ActiveRecord::RecordNotFound
			flash[:notice] = "Creating Invite"
	end

	#Check if user has already accepted the invitation
	def already_invited
		invite_accepted = Invite.find_by invitee_id: session[:user_id], confirm: true

		if invite_accepted != nil
			flash[:alert] = "You've already accepted invitation"
        	redirect_to users_path
		end

		rescue ActiveRecord::RecordNotFound
			flash[:notice] = "Confirming Invite"
	end

	def	reward_inviter(inviter_id)
		inviter = User.find(inviter_id)
		inviter.update({:reward => 1})
	end

	def	reward_other_inviters(inviter_id, amount)
		inviter_invite = Invite.find_by invitee_id: inviter_id, confirm: true

		if inviter_invite != nil then 
			other_inviter = User.find(inviter_invite.user_id) 
			if other_inviter != nil then
				other_inviter.update({:reward => other_inviter.reward + amount})
				return other_inviter.id
			end
		end

		return nil

		rescue ActiveRecord::RecordNotFound
			return nil
	end
end
