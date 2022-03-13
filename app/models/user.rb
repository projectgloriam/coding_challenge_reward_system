class User < ApplicationRecord
    has_many :users, through: :invites
end
