# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#Make root users before others so he can invite others
users = User.create([{name: "Root", reward: 0}, {name: "Fritz", reward: 0}, {name: "Caramel", reward: 0}, {name: "Michael", reward: 0}])
root_user = users.first
invite = Invite.create(user_id: nil, invitee_id: root_user.id, confirm: 1)