require 'rubygems'
require 'active_record'
require 'active_support/core_ext'
require 'mysql2'
require_relative '../lib/gga_services'

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: "localhost",
  username: "john",
  password: "schuster",
  database: "gga"
)

class Vote < ActiveRecord::Base
  self.primary_key = "id"
end

class MemberVote < ActiveRecord::Base
  self.primary_key = "id"
end

votes = Vote.all
vote_service = GGAServices::Vote.new

votes.each do |vote|
  vote_detail = vote_service.get_vote(vote[:id])
  vote_detail[:votes][:member_vote].each do |v|
    member_vote = Hash.new
    member_vote[:vote_id] = vote_detail[:vote_id]
    member_vote[:member_id] = v[:member][:id]
    member_vote[:voted] = v[:member_voted]

    MemberVote.create(member_vote)
  end
end
