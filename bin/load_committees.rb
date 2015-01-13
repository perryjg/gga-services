require 'rubygems'
require 'active_record'
require 'active_support/core_ext'
require 'mysql2'
require_relative '../lib/gga_services'

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: ENV["GGA_HOST"],
  username: ENV["GGA_USER"],
  password: ENV["GGA_PASSWORD"],
  database: ENV["GGA_DATABASE"]
)

sessions = [24,23,22,21,20,18,15,14,13,11,7,6,1]

class Committee < ActiveRecord::Base
  self.primary_key = 'id'
end

class MemberCommittee < ActiveRecord::Base
end

class SubCommittee < ActiveRecord::Base
  self.primary_key = 'id'
end

sessions.each do |session|
  committee_service = GGAServices::Committee.new
  committee_list = committee_service.get_committees_by_session({session_id: session}).body[:get_committees_by_session_response][:get_committees_by_session_result][:committee_listing]

  committee_list.each do |c|
    sleep 2
    committee_detail = committee_service.get_committee_for_session({committee_id: c[:id], session_id: session}).body[:get_committee_for_session_response][:get_committee_for_session_result]
    # f = File.open('docs/comittee_detail.rb', 'w')
    # f.write(committee_detail)
    # f.close

    begin
      committee_detail[:session_id] = committee_detail.delete(:session)[:id]
    rescue
      next
    end

    sub_committees = committee_detail.delete(:sub_committees)
    # if sub_committees
    #   sub_committees[:sub_committee].each do |s|
    #     s[:committee_id] = committee_detail[:id]
    #     puts ''
    #     puts ">>>>>>>>>>>>>SUB COMMITTEE>>>>>>>>>>>>>>>>>"
    #     p s
    #     puts ''
    #     SubCommittee.find_or_create_by(id: s[:id]).update(s)
    #   end
    # end
    members = committee_detail.delete(:members)[:committee_member]
    members.each do |m|
      puts ''
      puts ">>>>>>>>>>>>>>>>>Member<<<<<<<<<<<<<<<<"
      p m
      puts ''
      unless m[:date_vacated]
        member_committee = {}
        member_committee[:committee_id] = committee_detail[:id]
        member_committee[:member_id] = m[:member][:id]
        member_committee[:committee_name] = committee_detail[:name]
        member_committee[:role] = m[:role]
        member_committee[:session_id] = session

        # puts ''
        # puts ">>>>>>>>>>>>>>>>>MemberCommittee<<<<<<<<<<<<<<<<"
        # p member_committee
        # puts ''

        MemberCommittee.find_or_create_by(member_id: member_committee[:member_id],
                                          committee_id: member_committee[:committee_id],
                                          committee_name: member_committee[:committee_name],
                                          role: member_committee[:roll],
                                          session_id: member_committee[:session_id]).update(member_committee)
      end
    end

    committee_detail[:session_id] = session
    committee_detail[:committee_type] = committee_detail.delete(:type)
    committee_detail.delete(:address)
    committee_detail.delete(:session)
    committee_detail.delete(:session_contexts)
    committee_detail.delete(:staff)
    committee_detail.delete(:"@xmlns:a")
    committee_detail.delete(:"@xmlns:i")

    # puts ''
    # puts ">>>>>>>>>>>>>>>>>>>>>>COMMITTEE<<<<<<<<<<<<<<<<<"
    # p committee_detail
    # puts ''
    Committee.find_or_create_by(id: committee_detail[:id]).update(committee_detail)
  end
  sleep(2)
end

