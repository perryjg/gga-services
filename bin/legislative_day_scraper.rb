require 'open-uri'
require 'nokogiri'
require 'active_record'
require 'mysql2'
require 'logger'


LOG = Logger.new('logs/days_left_log.txt', 'monthly')
# LOG = Logger.new(STDOUT)
LOG.level = Logger::INFO

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: ENV["GGA_HOST"],
  username: ENV["GGA_USER"],
  password: ENV["GGA_PASSWORD"],
  database: ENV["GGA_DATABASE"]
)

class LegislativeDay < ActiveRecord::Base
  self.table_name = "gga_staging.legislative_days"
  self.primary_key = "id"
end

begin
  page = Nokogiri::HTML(open('http://www.house.ga.gov/clerk/en-US/HouseCalendars.aspx'))
rescue => error
  LOG.fatal error
  fail
end

items = page.xpath('//select')

if items.length == 0
  LOG.fatal 'No select elements found on page'
  fail
end

items.each do |select|
  next unless  select["id"].match(/Legislative Day/)

  if select.children.length == 0
    LOG.fatal "No select options found in select element"
    fail
  end

  select.children.each do |option|
    next unless option["value"]
    next if option["value"].match(/2015/)
    day = Hash.new
    day[:legislative_day_date] = option["value"]

    option.children[0].content.match(/Day (\d+)/)
    day[:id] = $1.to_i
    puts day

    begin
      LegislativeDay.find_or_create_by(id: day[:id]).update(day)
    rescue => error
      LOG.error error
    end
  end
end

begin
  ActiveRecord::Base.connection.execute('call gga.reload_days()')
rescue => error
  LOG.error error
else
  LOG.info("days table successfully updated")
end

today = Time.now.strftime('%Y-%m-%d')
legislative_day = LegislativeDay.find_by legislative_day_date: today
LOG.info "#{40 - legislative_day.id} days left in session"




