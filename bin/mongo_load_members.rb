require 'mongo'
require 'json'
require_relative '../lib/gga_services'

#include GGAServices
include Mongo

mongo_client = MongoClient.new("localhost")
ggadb = mongo_client.db("gga")
members_collection = ggadb.collection("members_list")
members_detail = ggadb.collection("members_detail")

session = 23
members_service = GGAServices::Member.new
members = members_service.get_members_by_session(session)

members_collection.remove("session_id" => 23)
members.each do |member|
  members_collection.insert(member)

  member_detail = members_service.get_member(member[:id])
  puts ''
  p member_detail[:sessions_in_service][:legislative_service]
end
