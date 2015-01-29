require 'rubygems'
require 'active_record'
require 'mysql2'
require 'logger'
require 'rest_client'

LOG = Logger.new('logs/versions_log.txt', 'weekly')
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
  self.table_name = 'gga.versions'
end

versions = Version.where('dc_id is null')
params = {
  source: 'Georgia General Assembly',
  project: 17285,
  access: 'public'
}

versions.each do |version|
  puts version.id
  params[:file] = version.url
  params[:title] = version.id
  params[:description] = version.description
  params[:data] = { version: version.version, bill_id: version.bill_id }

  result = RestClient.post("https://John.Perry%40ajc.com:#{ENV["DC_PASS"]}@www.documentcloud.org/api/upload.json", params)

  if result.code == 200
    result_data = JSON.parse(result)
    version.dc_id = result_data["id"]
    version.dc_url = result_data["canonical_url"]

    begin
      version.save
    rescue => error
      LOG.error error
    end
    LOG.info "Uploaded bill version #{version.id} to #{version.dc_id}"
  else
    LOG.error "HTTP error | bill_id: #{version.bill_id}, version_id: #{version.id}, error code: #{result.code}"
  end
end

LOG.info('STOP')
ActiveRecord::Base.connection.close
