require 'rubygems'
require 'active_record'
require 'active_support/core_ext'
require 'mysql2'
require 'logger'
require_relative '../lib/gga_services'

LOG = Logger.new('logs/text_log.txt', 'weekly')
LOG.level = Logger::INFO
LOG.info('START')

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: ENV["GGA_HOST"],
  username: ENV["GGA_USER"],
  password: ENV["GGA_PASSWORD"],
  database: ENV["GGA_DATABASE"]
)

class Version < ActiveRecord::Base
end

class Text < ActiveRecord::Base
  self.table_name = "bills_text"
  self.primary_key = "version_id"
end

bills = Version.all.order(id: :desc).where("url like '20152016'")

text_service = GGAServices::LegislationText.new

bills.each do |bill|
  begin
    text = text_service.get_legislation_text(bill.id)
  rescue
    LOG.error("Version No.: #{bill.id}")
  end

  puts text
  LOG.info("Bill: #{bill.bill_id}")
  LOG.info("Version: #{bill.id}")
  LOG.info("URL: #{bill.url}")
  LOG.info("")
  text = Text.new(
    version_id: bill.id,
    bill_id: bill.bill_id,
    url: bill.url,
    text: text
  )
  text.save
  sleep(1)
end
