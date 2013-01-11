require 'rubygems'
require 'dbi'
require_relative '../lib/gga_services'

include GGAServices

connect_string = 'DBI:Mysql:gga_services:XXXX'
@dbh = DBI.connect( connect_string,
                    "XXXX",
                    "XXXX" )
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

sessions = [1, 6, 7, 11, 13, 14, 15, 18, 20, 21, 22, 23]
sql_format = 'INSERT IGNORE INTO sessions_members 
              VALUES(%s",%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s")'

members_service = Member.new

sessions.each do |session|
  print "Session #{session}"
  members = members_service.get_members_by_session({session_id: session}).body[:get_members_by_session_response][:get_members_by_session_result][:member_listing]

  count = 0
  members.each do |member|
    member[:name][:nickname] = member[:name][:nickname].blank? ? member[:name][:nickname] : member[:name][:nickname].sub( %r{\\"}, "")
    sql = sql_format % [ member[:date_vacated].blank? ? '' : member[:date_vacated].to_date.to_s,
                         member[:district][:coverage],
                         member[:district][:post],
                         member[:district][:id],
                         member[:district][:type],
                         member[:district][:number],
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
                         member[:party],
                         member[:id],
                         session ]
    
    begin
      count += @dbh.do( sql )
    rescue DBI::DatabaseError => e
      print e.errstr
    rescue => e
      print e.message
    end
  end
end
print "#{count} records inserted"
