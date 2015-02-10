require 'rubygems'
require 'active_record'
require 'active_support/core_ext'
require 'mysql2'
require 'logger'
require_relative '../lib/gga_services'

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: ENV["GGA_HOST"],
  username: ENV["GGA_USER"],
  password: ENV["GGA_PASSWORD"],
  database: ENV["GGA_DATABASE"]
)

LOG = Logger.new("logs/votes_log.txt", "weekly")
LOG.level = Logger::INFO
LOG.info("START")

class Vote < ActiveRecord::Base
  self.primary_key = "id"
end

class MemberVote < ActiveRecord::Base
  self.primary_key = "id"
  validates :member_id, uniqueness: { scope: :vote_id }
end

begin
  # votes = Vote.where("vote_date >= '#{1.day.ago.to_date}'")
  votes = Vote.where("vote_date >= '2015-01-01'")
rescue => error
  LOG.fatal error
  fail
end

# puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
# puts votes.length
# puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

if votes.length > 0
  LOG.info("New votes found for #{1.day.ago.to_date}: #{votes.length}")
  vote_service = GGAServices::Vote.new

  votes.each do |vote|
    begin
      vote_detail = vote_service.get_vote(vote[:id])
    rescue => error
      LOG.error("#{error} (Vote ID: #{vote[:id]})")
    end

    vote_detail[:votes][:member_vote].each do |v|
      member_vote = Hash.new
      member_vote[:vote_id] = vote_detail[:vote_id]
      member_vote[:member_id] = v[:member][:id]
      member_vote[:voted] = v[:member_voted]

      new_member_vote = MemberVote.new(member_vote)
      new_member_vote.save if new_member_vote.valid?
    end
  end

  begin
    ActiveRecord::Base.connection.execute('call gga.reload_member_votes')
  rescue => error
    LOG.error error
  else
    LOG.info("Member vote data successfully reloaded")
  end

else
  LOG.info("No new votes found")
end

LOG.info("STOP")
