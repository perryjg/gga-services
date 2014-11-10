require 'rubygems'
require 'active_record'
require 'active_support/core_ext'
require 'mysql2'
require_relative '../lib/gga_services'

# ActiveRecord::Base.establish_connection(
#   adapter: "mysql2",
#   host: "ajc-web.cgmwsizvte0i.us-east-1.rds.amazonaws.com",
#   username: "newsappweb",
#   password: "webat223",
#   database: "gga_staging"
# )

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: ENV["GGA_HOST"],
  username: ENV["GGA_USER"],
  password: ENV["GGA_PASSWORD"],
  database: ENV["GGA_DATABASE"]
)

class Member < ActiveRecord::Base
  self.primary_key = "id"
end

class LegislativeService < ActiveRecord::Base
  self.primary_key = "id"
end

member_service = GGAServices::Member.new
# sessions = [23,22,21,20,18,15,14,13,11,7,6,1]
sessions = [23]

sessions.each do |session|
  puts ">>>>>>>>>SESSION: #{session}"
  members = member_service.get_members_by_session(session)

  members.each do |member|
    puts ">>>>>>>>>MEMBER ID: #{member[:id]}"
    member_detail = member_service.get_member(member[:id])

    name = member_detail.delete(:name)
    name.keys.each do |key|
      member_detail["name_#{key}".to_sym] = name[key]
    end

    address = member_detail.delete(:address)
    address.keys.each do |key|
      # puts "#{address[key]}: #{address[key].class}"
      member_detail["address_#{key}".to_sym] = address[key]
    end

    district_address = member_detail.delete(:district_address)
    district_address.keys.each do |key|
      # puts "#{district_address[key]}: #{district_address[key].class}"
      member_detail["district_address_#{key}".to_sym] = district_address[key]
    end

    sessions_in_service = member_detail.delete(:sessions_in_service)
    legislative_service = sessions_in_service[:legislative_service]

    legislative_service.each do |service|
      session = service.delete(:session)
      district = service.delete(:district)

      service[:id] = service.delete(:service_id)
      service[:member_id] = member_detail[:id]
      service[:session_id] = session[:id]
      service[:coverage] = district[:coverage]
      service[:post] = district[:post]
      service[:district_type] = district[:type]
      service[:district_number] = district[:number]

      service.delete(:committee_memberships)
      LegislativeService.find_or_create_by(id: service[:id]).update(service)
    end

    member_detail.delete(:free_form1)
    member_detail.delete(:free_form2)
    member_detail.delete(:legislative_comments)
    member_detail.delete(:staff)
    Member.find_or_create_by(id: member_detail[:id]).update(member_detail)

    sleep(1)
    break
  end
end
