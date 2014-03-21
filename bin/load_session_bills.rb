require 'rubygems'
require 'active_record'
require 'active_support/core_ext'
require 'mysql2'
require 'logger'
require_relative '../lib/gga_services'

LOG = Logger.new('logs/bills_log.txt', 'weekly')
LOG.level = Logger::INFO
LOG.info('START')

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: ENV["GGA_HOST"],
  username: ENV["GGA_USER"],
  password: ENV["GGA_PASSWORD"],
  database: ENV["GGA_DATABASE"]
)

class BillIndex < ActiveRecord::Base
  self.table_name = "bills_index"
end

class Bill < ActiveRecord::Base
end

class Sponsorship < ActiveRecord::Base
  self.primary_key = "id"
end

# class Committee < ActiveRecord::Base
# end

class BillsCommittee < ActiveRecord::Base
end

class Status < ActiveRecord::Base
  self.primary_key = "id"
end

class BillStatusListing < ActiveRecord::Base
  self.primary_key = "id"
end

class Version < ActiveRecord::Base
end

class Vote < ActiveRecord::Base
end

# sessions = [23,22,21,20,18,15,14,13,11,7,6,1]
sessions = [23]
house = {
  "HB" => "house",
  "HR" => "house",
  "SB" => "senate",
  "SR" => "senate"
}

bill_service = GGAServices::Legislation.new
sessions.each do |session|
  begin
    bill_index = bill_service.get_legislation_for_session(session)
  rescue => error
    LOG.fatal error
    fail
  end

  bill_index.each do |bill|
    next if bill[:id] == '5080'
    bill['session_id'] = session

    # puts ""
    # puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    # puts "#{session}: #{bill[:id]}"
    # puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    # puts ""
    begin
      BillIndex.find_or_create_by(id: bill[:id]).update(bill)
    rescue => error
      LOG.error error
    end

    sleep(2)
    begin
      bill_detail = bill_service.get_legislation_detail( bill[:id] )
    rescue
      puts ">>>>>>>>>>> Sleeping 2 min <<<<<<<<<<<<<<"
      begin
        puts ">>>>>>>>>>>>> Trying again <<<<<<<<<<<<<<<"
        sleep(120)
        bill_detail = bill_service.get_legislation_detail( bill[:id] )
      rescue => error
        LOG.error( "#{error} (Bill ID: #{bill[:id]})" )
      end
    end

    # puts ""
    # puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    # puts bill_detail[:status][:date].to_date
    # puts bill_detail[:status][:date].to_date == 1.day.ago.to_date
    # puts "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    # puts ""

    # if bill_detail[:status][:date].to_date >= 7.days.ago.to_date
      LOG.debug("Updating Bill ID #{bill[:id]}")

      #pull out child records -- convert to array if just one record
      authors = bill_detail.delete(:authors)
      committees = bill_detail.delete(:committees)
      statusHistory = bill_detail.delete(:status_history)
      versions = bill_detail.delete(:versions)
      votes = bill_detail.delete(:votes)

      #flatten hash where necessary
      bill_detail[:latest_version_id] = bill_detail[:latest_version][:id]
      bill_detail[:latest_version_description] = bill_detail[:latest_version][:description]
      bill_detail[:latest_version_url] = bill_detail[:latest_version][:url]
      bill_detail.delete(:latest_version)

      bill_detail[:session_id] = bill_detail[:session][:id]
      bill_detail.delete(:session)

      if bill_detail[:status]
        bill_detail[:status_id] = bill_detail[:status][:id]
        bill_detail[:status_date] = bill_detail[:status][:date].to_datetime.to_s
        bill_detail[:status_description] = bill_detail[:status][:description]
      end
      bill_detail.delete(:status)

      if bill_detail[:sponsor]
        bill_detail["#{bill_detail[:sponsor][:type].underscore}_id".to_sym] = bill_detail[:sponsor][:id]
        bill_detail["#{house[bill_detail[:document_type]]}_sponsor_id".to_sym] = authors[:sponsorship].select {|s| s[:sequence] == "1"}[0][:id]
        bill_detail[:member_id] = authors[:sponsorship].select {|s| s[:sequence] == "1"}[0][:id]
      end
      bill_detail.delete(:sponsor)

      #delete the crap at the end
      # bill_detail.delete(:"@xmlns:a")
      # bill_detail.delete(:"@xmlns:i")

      #Load data
      begin
        Bill.find_or_create_by(id: bill_detail[:id]).update(bill_detail)
      rescue => error
        LOG.error( "#{error} (Bill ID: #{bill[:id]}" )
      end

      if authors
        authors[:sponsorship].each do |s|
          s[:sponsorship_type] = s.delete(:type);
          s[:bill_id] = bill_detail[:id]
          Sponsorship.find_or_create_by(id: s[:id]).update(s)
        end
      end

      # if committees
      #   committees[:committee_listing].each do |c|
      #     c[:committee_type] = c.delete(:type)
      #     Committee.find_or_create_by(id: c[:id]).update(c)

      #     c[:committee_id] = c.delete(:id)
      #     c[:bill_id] = bill_detail[:id]
      #     BillsCommittee.find_or_create_by(bill_id: bill_detail[:id], committee_type: c[:committee_type]).update(c)
      #   end
      # end

      if statusHistory
        statusHistory[:status_listing].each do |status|
          status[:status_id] = status.delete(:id)
          status[:bill_id] = bill_detail[:id]
          status[:status_date] = status[:date].to_datetime.to_s
          status[:document_type] = bill_detail[:document_type]
          status[:number] = bill_detail[:number]
          status[:caption] = bill_detail[:caption]
          status.delete(:date)

          begin
            BillStatusListing.find_or_create_by(bill_id: status[:bill_id], code: status[:code]).update(status)
          rescue => error
            LOG.error error
          end

          status[:id] = status[:status_id]

          begin
            Status.find_or_create_by(id: status[:id]).update(status.slice(:id, :code, :description))
          rescue => error
            LOG.error error
          end
        end
      end

      versions[:document_description].each do |v|
        v[:bill_id] = v.delete(:legislation_id)

        begin
          Version.find_or_create_by(id: v[:id]).update(v)
        rescue => error
          LOG.error error
        end
      end

      if votes
        votes[:vote_listing].each do |v|
          v[:id] = v.delete(:vote_id)
          v[:bill_id] = bill_detail[:id]
          v[:vote_date] = v[:date].to_datetime.to_s
          v[:session_id] = v[:session][:id]
          v[:title] = bill_detail[:caption]
          v.delete(:date)
          v.delete(:session)
          v.delete(:day)
          v.delete(:time)

          begin
            Vote.find_or_create_by(id: v[:id]).update(v)
          rescue => error
            LOG.error error
          end
        end
      # end
    end
  end
end

begin
  ActiveRecord::Base.connection.execute('call reload_bill_attributes()')
rescue => error
  LOG.error error
else
  LOG.info("bills_attributes table created")
end

# begin
#   ActiveRecord::Base.connection.execute('call archive_predictions()')
# rescue => error
#   LOG.error error
# else
#   LOG.info("predictions archived")
# end

# begin
#   system("R CMD BATCH #{File.dirname(__FILE__)}/crossover_model_final.R")
# rescue => error
#   LOG.error error
# else
#   LOG.info("predictions calculated")
# end

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

# begin
#   ActiveRecord::Base.connection.execute('call gga.create_passed_table()')
# rescue => error
#   LOG.error error
# else
#   LOG.info("passed table successfully created")
# end

begin
  ActiveRecord::Base.connection.execute('call gga.reload_versions()')
rescue => error
  LOG.error error
else
  LOG.info("versions table successfully reloaded")
end

begin
  ActiveRecord::Base.connection.execute('call gga.reload_sponsorships()')
rescue => error
  LOG.error error
else
  LOG.info("sponsorships table successfully reloaded")
end

begin
  ActiveRecord::Base.connection.execute('call gga.update_watched_bills()')
rescue => error
  LOG.error error
else
  LOG.info("watched_bills table successfully updated")
end

LOG.info('STOP')
