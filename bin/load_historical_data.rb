require 'rubygems'
require 'dbi'
require_relative '../lib/gga_services'

include GGAServices

connect_string = 'DBI:Mysql:gga_services:ajc-intranet.cgmwsizvte0i.us-east-1.rds.amazonaws.com'
@dbh = DBI.connect( connect_string,
                    "ajcnews",
                    "KbZ776Pd" )
sql_format = 'INSERT IGNORE INTO sessions VALUES("%s","%s","%s","%s"")'

sessions_service = LegislativeSession.new
sessions = sessions_service.get_sessions.body[:get_sessions_response][:get_sessions_result][:session]

count = 0
sessions.each do |session|
  sql = sql_format % [ session[:is_default], session[:id], session[:description], session[:library] ]
  
  begin
    count += @dbh.do( sql )
  rescue DBI::DatabaseError => e
    print e.errstr
  rescue => e
    print e.message
  end
end

print "#{count} records inserted"