class WelcomeController < ApplicationController

  def index
    #Reset reward to 0.0
    User.all.each do |user|
      user.update({:reward => 0})
    end

    #Delete all invites
    Invite.delete_all

    #fetching input from curl post
    @input = request.raw_post

    #splitting string to array
    request = @input.split("\r\n")

    #fetching "recommends" or "accepts" statements
    request.each do |r|
      #splitting into words
      data = r.scan(/\w+/)

      #fetching index of "recommends" word
      a_index = data.bsearch_index {|x| x == "recommends" }

      if a_index != nil then
        #fetching party before recommend word
        partyA = data[a_index - 1]
        partyB = data[a_index + 1]

        #fetching or creating user A
        partyAUser = fetch_or_create_user(partyA)
		
        #fetching or creating user B
        partyBUser = fetch_or_create_user(partyB)

        invite = Invite.create(user_id: partyAUser.id, invitee_id: partyBUser.id, confirm: 0)
      else
        #or fetching index of "accepts" word
        a_index = data.bsearch_index {|x| x == "accepts" } 
        partyB = data[a_index - 1]

        #fetching or creating user B
        partyBUser = fetch_or_create_user(partyB)

        #fetching first instance of invite containing party B and confirming it
        invite = Invite.find_by(invitee_id: partyBUser.id, confirm: 0)
        invite.update({:confirm => 1})

        #Reward inviters
        reward = 1.0;
        
        loop do
          inviter_id = invite.user_id
          #find inviter as a user
          inviter = User.find(inviter_id)
          
          #reward inviter
          inviter.update({:reward => inviter.reward + reward})
           
          # checking if inviter has another inviter up the chain
          if Invite.exists?(:invitee_id => inviter.id, :confirm => 1) then
            #fetch the invite
            invite = Invite.find_by(:invitee_id => inviter.id, :confirm => 1)

            #(1/2)^k points of reward for next level inviter
            reward /= 2
          else
            break
          end

         # ending of ruby do..while loop
        end

      end

    end

    #Fetching all users
    users = User.all

    #creating a hash
    resultsHash = Hash.new

    #saving each user and reward to hash
    users.each {|u| resultsHash[u.name] = u.reward  }

    @results = resultsHash.to_json

    render :json => @results
  end

  def fetch_or_create_user(username)
    if User.exists?(:name => username) then
      user = User.find_by :name => username
    else
      user = User.create(name: username, reward: 0)
    end

    return user
  end

end
