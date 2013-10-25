require 'rubygems'
require 'active_record'
require 'active_support/core_ext'
require 'mysql2'
require_relative '../lib/gga_services'

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: "localhost",
  username: "john",
  password: "schuster",
  database: "gga"
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

#sessions = [23,22,21,20,18,15,14,13,11,7,6,1]
sessions = [1]
house = {
  "HB" => "house",
  "HR" => "house",
  "SB" => "senate",
  "SR" => "senate"
}

bill_service = GGAServices::Legislation.new
sessions.each do |session|
  bill_index = bill_service.get_legislation_for_session({session_id: session}).body[:get_legislation_for_session_response][:get_legislation_for_session_result][:legislation_index]
  bill_index.each do |bill|
    bill['session_id'] = session
    p bill
    BillIndex.find_or_create_by(id: bill[:id]).update(bill)

    bill_detail = bill_service.get_legislation_detail({legislation_id: bill[:id]}).body[:get_legislation_detail_response][:get_legislation_detail_result]
    
    puts ""
    puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    p bill_detail
    puts "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts ""


    #pull out child records -- convert to array if just one record
    authors = bill_detail.delete(:authors)
    if authors
      authors[:sponsorship] = [authors[:sponsorship]] if authors[:sponsorship].kind_of?(Hash)
    end

    committees = bill_detail.delete(:committees)
    if committees
      committees[:committee_listing] = [committees[:committee_listing]] if committees[:committee_listing].kind_of?(Hash)
    end

    statusHistory = bill_detail.delete(:status_history)
    statusHistory[:status_listing] = [statusHistory[:status_listing]] if statusHistory[:status_listing].kind_of?(Hash)

    versions = bill_detail.delete(:versions)
    versions[:document_description] = [versions[:document_description]] if versions[:document_description].kind_of?(Hash)

    votes = bill_detail.delete(:votes)
    if votes
      votes[:vote_listing] = [votes[:vote_listing]] if votes[:vote_listing].kind_of?(Hash)
    end

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
    end
    bill_detail.delete(:sponsor)

    #delete the crap at the end
    bill_detail.delete(:"@xmlns:a")
    bill_detail.delete(:"@xmlns:i")

    #Load data
    Bill.find_or_create_by(id: bill_detail[:id]).update(bill_detail)

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
        BillStatusListing.find_or_create_by(bill_id: status[:bill_id], code: status[:code]).update(status)

        status[:id] = status[:status_id]
        Status.find_or_create_by(id: status[:id]).update(status.slice(:id, :code, :description))
      end
    end

    versions[:document_description].each do |v|
      v[:bill_id] = v.delete(:legislation_id)
      Version.find_or_create_by(id: v[:id]).update(v)
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

        Vote.find_or_create_by(id: v[:id]).update(v)
      end
    end
  end
  sleep(3)
end

