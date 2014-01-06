# Old version of the script -- DO NOT USE

require 'rubygems'
require 'dbi'
require_relative '../lib/gga_services'

include GGAServices

#connect_string = 'DBI:Mysql:gga_services:ajc-intranet.cgmwsizvte0i.us-east-1.rds.amazonaws.com'
# @dbh = DBI.connect( connect_string,
#                     "",
#                     ""
# )
connect_string = 'DBI:Mysql:gga:localhost'
@dbh = DBI.connect( connect_string,
                    "john",
                    "schuster"
)

def load_member_committee(member_id, session_id, service_id, committee)
    committee_format = 'INSERT IGNORE INTO member_committees
        VALUES("%s","%s","%s","%s","%s","%s")'

    committee_sql = committee_format % [
        committee[:committee][:id],
        member_id,
        session_id,
        service_id,
        committee[:roll],
        committee[:date_vacated]
    ]
    begin
        @dbh.do(committee_sql)
    rescue DBI::DatabaseError => e
        print e.errstr
    rescue => e
        print e.message
    end
end


def load_service(lservice, member_id)
    service_format = 'INSERT IGNORE INTO legislative_services
        VALUES("%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s")'

    service_sql = service_format % [
        lservice[:service_id],
        member_id,
        lservice[:session][:id],
        lservice[:leg_id],
        lservice[:party],
        lservice[:date_vacated],
        lservice[:district][:coverage],
        lservice[:district][:post],
        lservice[:district][:type],
        lservice[:district][:number],
        lservice[:title]
    ]
    begin
        @dbh.do(service_sql)
    rescue DBI::DatabaseError => e
        print e.errstr
    rescue => e
        print e.message
    end

    if not lservice[:committee_memberships].blank?
        if lservice[:committee_memberships][:committee_membership].class == Hash
            load_member_committee(member_id,
                                  lservice[:session][:id],
                                  lservice[:service_id],
                                  lservice[:committee_memberships][:committee_membership]
            )
        else
            lservice[:committee_memberships][:committee_membership].each do |committee|
                load_member_committee(member_id,
                                      lservice[:session][:id],
                                      lservice[:service_id],
                                      committee
                )
            end
        end
    end
end

# sql_format = 'INSERT IGNORE INTO sessions VALUES("%s","%s","%s","%s"")'

# sessions_service = LegislativeSession.new
# sessions = sessions_service.get_sessions.body[:get_sessions_response][:get_sessions_result][:session]

# count = 0
# sessions.each do |session|
#   sql = sql_format % [ session[:is_default], session[:id], session[:description], session[:library] ]

#   begin
#     count += @dbh.do( sql )
#   rescue DBI::DatabaseError => e
#     print e.errstr
#   rescue => e
#     print e.message
#   end
# end

# print "#{count} records inserted"

# sessions = [1, 6, 7, 11, 13, 14, 15, 18, 20, 21, 22, 23]
#sessions = [23,22,21,20,18,15,14,13,11,7,6,1]
sessions = [23,22,21,20,18,15,14,13,11,7,6,1]

member_session_format = 'INSERT IGNORE INTO session_members
    VALUES("%s","%s")'

member_format = 'INSERT IGNORE INTO members
    VALUES("%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s")'

members_service = Member.new

sessions.each do |session|
  print "Session #{session}"
  members_session = members_service.get_members_by_session({session_id: session}).body[:get_members_by_session_response][:get_members_by_session_result][:member_listing]

  count = 0
  members_session.each do |member_session|
    member_session_sql = member_session_format % [ member_session[:id], session]
    @dbh.do( member_session_sql )

    member = members_service.get_member({member_id: member_session[:id]}).body[:get_member_response][:get_member_result]
    member[:name][:nickname] = member[:name][:nickname].blank? ? member[:name][:nickname] : member[:name][:nickname].sub( %r{\\"}, "")
    member_sql = member_format % [
         member[:date_vacated].blank? ? '' : member[:date_vacated].to_date.to_s,
         member_session[:district][:coverage],
         member_session[:district][:post],
         member_session[:district][:id],
         member_session[:district][:type],
         member_session[:district][:number],
         member[:address][:city],
         member[:address][:email],
         member[:address][:fax],
         member[:address][:phone],
         member[:address][:state],
         member[:address][:street],
         member[:address][:zip],
         member[:district_address][:city],
         member[:district_address][:email],
         member[:district_address][:fax],
         member[:district_address][:phone],
         member[:district_address][:state],
         member[:district_address][:street],
         member[:district_address][:zip],
         member[:leg_id],
         member[:name][:first],
         member[:name][:last],
         member[:name][:middle],
         member[:name][:nickname],
         member_session[:party],
         member[:birthday],
         member[:education],
         member[:occupation],
         member[:religion],
         member[:spouse],
         member[:cellphone],
         member[:id]
       ]

    begin
      count += @dbh.do( member_sql )
    rescue DBI::DatabaseError => e
      print e.errstr
    rescue => e
      print e.message
    end

    if member[:sessions_in_service][:legislative_service].class == Hash
        load_service(member[:sessions_in_service][:legislative_service], member_session[:id])
    else
        member[:sessions_in_service][:legislative_service].each do |legislative_service|
            load_service( legislative_service, member_session[:id])
        end
    end
    print "Session: #{session} - Member #{member[:id]}"
  end
  print "#{count} records inserted"
end

