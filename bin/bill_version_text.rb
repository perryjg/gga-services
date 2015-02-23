require 'rubygems'
require 'active_record'
require 'mysql2'
require 'logger'
require 'rest_client'

LOG = Logger.new('logs/versions_log.txt', 'weekly')
LOG.level = Logger::DEBUG
LOG.info('START')

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: ENV["GGA_HOST"],
  username: ENV["GGA_USER"],
  password: ENV["GGA_PASSWORD"],
  database: ENV["GGA_DATABASE"]
)

class Bill < ActiveRecord::Base
  has_many :versions
end

class Version < ActiveRecord::Base
  belongs_to :bill
end

versions = Version.where("dc_id is null")
params = {
  source: 'Georgia General Assembly',
  project: 18221,
  access: 'public'
}

versions.each do |version|
  bill = version.bill

  LOG.debug("Checking for existing bill version #{version.id}")
  result = JSON.parse( RestClient.get("https://www.documentcloud.org/api/search.json?q=projectid:18221+version_id:#{version.id}&data=true") )
  next if result["total"] > 0

  LOG.debug("Checking for previous versions of bill #{version.bill_id}")
  result = JSON.parse( RestClient.get("https://www.documentcloud.org/api/search.json?q=projectid:18221+bill_id:#{version.bill_id}&data=true") )
  if result["total"] > 0
    LOG.debug("#{result["total"]} previous versions of bill #{bill["id"]} found")
    result["documents"].each do |doc|
      data = doc["data"]
      data["current"] = false

      update_url = "https://John.Perry%40ajc.com:#{ENV["DC_PASS"]}@www.documentcloud.org/api/documents/#{doc["id"]}.json"
      LOG.debug("Sending update request: #{update_url}")

      r = RestClient.put(update_url, {data: data})
      LOG.debug("Update return code: #{r.code}")
    end
  end

  params[:file] = version.url
  params[:title] = "#{bill.document_type} #{bill.number}"
  params[:description] = version.description
  params[:data] = {
    id: version.id,
    version: version.version,
    bill_id: version.bill_id,
    current: true
  }

  result = RestClient.post("https://John.Perry%40ajc.com:#{ENV["DC_PASS"]}@www.documentcloud.org/api/upload.json", params)

  if result.code == 200
    LOG.info "Uploaded bill version #{version.id} to #{version.dc_id}"
    result_data = JSON.parse(result)
    version.dc_id = result_data["id"]
    version.dc_url = result_data["canonical_url"]

    begin
      v = version.save
      LOG.debus("Version #{version.id} update result: #{v}")
    rescue => error
      LOG.error error
    end
  else
    LOG.error "HTTP error | bill_id: #{version.bill_id}, version_id: #{version.id}, error code: #{result.code}"
  end
  sleep 1
end

begin
  ActiveRecord::Base.connection.execute('call gga.reload_versions()')
rescue => error
  LOG.error error
else
  LOG.info("gga.versions table successfully reloaded")
end

LOG.info('STOP')
ActiveRecord::Base.connection.close
