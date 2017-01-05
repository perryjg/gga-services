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
  self.primary_key = "id"
end

class Text < ActiveRecord::Base
  self.table_name = "bills_text"
  self.primary_key = "version_id"
end

versions = Version.all.order(id: :desc).where("url like '%20172018%'")
LOG.info("#{versions.length} Records found")
text_service = GGAServices::LegislationText.new

versions.each do |version|
  begin
    text = text_service.get_legislation_text(version.id)
  rescue
    LOG.error("Version No. #{version.id}")
  end

  LOG.info("Bill: #{version.bill_id}")
  LOG.info("Version: #{version.id}")
  LOG.info("URL: #{version.url}")
  LOG.info("")
  data = {
    version_id: version.id,
    bill_id: version.bill_id,
    url: version.url,
    text: text
  }
  Text.find_or_create_by(version_id: version.id).update(data)
  sleep(1)
end
