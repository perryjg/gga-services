require 'rubygems'
require 'active_record'
require 'active_support/core_ext'
require 'mysql2'
require 'logger'


LOG = Logger.new('logs/bills_log.txt', 'weekly')
LOG.level = Logger::DEBUG
LOG.info('Start reload of gga')

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: ENV["GGA_HOST"],
  username: ENV["GGA_USER"],
  password: ENV["GGA_PASSWORD"],
  database: ENV["GGA_DATABASE"]
)



begin
  ActiveRecord::Base.connection.execute('call gga.reload_bills()')
rescue => error
  LOG.error error
else
  LOG.info("bills table successfully reloaded")
end

begin
  ActiveRecord::Base.connection.execute('call gga.reload_bill_status_listings()')
rescue => error
  LOG.error error
else
  LOG.info("bill_status_listings table successfully reloaded")
end

begin
  ActiveRecord::Base.connection.execute('call gga.create_passed_table()')
rescue => error
  LOG.error error
else
  LOG.info("passed table successfully created")
end

begin
  ActiveRecord::Base.connection.execute('call gga.reload_sponsorships()')
rescue => error
  LOG.error error
else
  LOG.info("sponsorships table successfully reloaded")
end

begin
  ActiveRecord::Base.connection.execute('call gga.reload_votes')
rescue => error
  LOG.error error
else
  LOG.info("Vote data successfully reloaded")
end

begin
  ActiveRecord::Base.connection.execute('call gga.reload_member_votes')
rescue => error
  LOG.error error
else
  LOG.info("Member vote data successfully reloaded")
end

begin
  ActiveRecord::Base.connection.execute('call gga.update_watched_bills()')
rescue => error
  LOG.error error
else
  LOG.info("watched_bills table successfully updated")
end

LOG.info("Completed reload of gga")
