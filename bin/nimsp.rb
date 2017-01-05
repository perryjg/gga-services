require "active_record"
require "mysql2"
require "net/http"
require "uri"
require "logger"

LOG = Logger.new('logs/contributions.log', 'weekly')
LOG.level = Logger::DEBUG
LOG.info('START')


def get_records(id,type,page)
  endpoint = {
    lawmaker: "http://api.followthemoney.org/?law-eid=%s&gro=y,d-eid,d-cci,d-ccb,d-ad-cty,d-ad-st,d-ad-zip,d-ins,d-empl,d-occupation&p=%d&APIKey=e8e96e97dbca58cbe698bf18cf3f53d2&mode=json",
    candidate: "http://api.followthemoney.org/?c-t-eid=%s&gro=y,d-eid,d-cci,d-ccb,d-ad-cty,d-ad-st,d-ad-zip,d-ins,d-empl,d-occupation&p=%d&APIKey=e8e96e97dbca58cbe698bf18cf3f53d2&mode=json"
  }
  puts sprintf(endpoint[type.to_sym], id, page)
  uri = URI.parse(sprintf(endpoint[type.to_sym], id, page))
  response = Net::HTTP.get_response(uri)
  response = JSON.parse(response.body)
  return response
end

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: ENV["GGA_HOST"],
  username: ENV["GGA_USER"],
  password: ENV["GGA_PASSWORD"],
  database: "gga_staging"
)

class MemberLawmakerMatch < ActiveRecord::Base
  self.primary_key = "gga_id"
end

class Contribution < ActiveRecord::Base
  self.primary_key = "id"
end

members = MemberLawmakerMatch.all

members.each do |member|
  LOG.info( "Member: #{member[:nimsp_name]}" )
  curpage = 0

  while 1==1
    data = {}
    response = {}

    if member.candidate_id
      response = get_records(member.candidate_id, 'candidate', curpage)
    elsif member.lawmaker_id
      response = get_records(member.lawmaker_id, 'lawmaker', curpage)
    end

    LOG.info("page #{response["metaInfo"]["paging"]["currentPage"]} of #{response["metaInfo"]["paging"]["maxPage"]}")
    LOG.info("#{response["metaInfo"]["paging"]["recordsThisPage"]} records")
    break if response["records"].include?("No Records")

    response["records"].each do |record|
      data[:member_id] = member[:gga_id]
      data[:election_year] = record["Election_Year"]["Election_Year"]
      data[:contributor_id] = record["Contributor"]["id"]
      data[:contributor_name] = record["Contributor"]["Contributor"]
      data[:contributor_type] = record["Type_of_Contributor"]["Type_of_Contributor"]
      data[:industry_id] = record["General_Industry"]["id"]
      data[:industry] = record["General_Industry"]["General_Industry"]
      data[:sector_id] = record["Broad_Sector"]["id"]
      data[:sector] = record["Broad_Sector"]["Broad_Sector"]
      data[:business] = record["Specific_Business"]["Specific_Business"]
      data[:city] = record["City"]["City"]
      data[:state] = record["State"]["State"]
      data[:zipcode] = record["Zip"]["Zip"]
      data[:in_district] = record["In-Jurisdiction"]["In-Jurisdiction"]
      data[:employer] = record["Employer"]["Employer"]
      data[:occupation] = record["Occupation"]["Occupation"]
      data[:contributions] = record["#_of_Records"]["#_of_Records"]
      data[:amount] = record["Total_$"]["Total_$"]

      begin
        Contribution.create(data)
      rescue => e
        LOG.error(e)
      end
    end

    break if response["metaInfo"]["paging"]["currentPage"] == response["metaInfo"]["paging"]["maxPage"]
    curpage += 1
  end
  sleep 5
end

