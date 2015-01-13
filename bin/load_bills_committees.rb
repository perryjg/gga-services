require 'rubygems'
require 'active_record'
require 'active_support/core_ext'
require 'mysql2'
require 'logger'
require_relative '../lib/gga_services'

LOG = Logger.new('logs/bill_committee.log', 'weekly')
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
end

class BillsCommittee < ActiveRecord::Base
end

bill_service = GGAServices::Legislation.new

sql =
"select distinct a.id
from bills a
left join bills_committees b
  on a.id = b.bill_id
where a.document_type in ('HB','SB')
  and b.committee_id is null
order by a.id desc"

bills = ActiveRecord::Base.connection.execute(sql)
bills.each do |bill|
  LOG.info("Requesting bill No. #{bill[0]}")

  sleep 2
  begin
    bill_detail = bill_service.get_legislation_detail(bill[0])
  rescue
    puts ">>>>>>>>>>> Sleeping 2 min <<<<<<<<<<<<<<"
    sleep 120
    begin
      puts">>>>>>>>>>>>> Trying again <<<<<<<<<<<<<<<"
      bill_detail = bill_service.get_legislation_detail(bill[0])
    rescue => error
      LOG.error error
    end
  end

  committee = bill_detail[:committees]
  if committee
    if committee[:committee_listing].class == Hash
      committee[:committee_listing] = [committee[:committee_listing]]
    end

    committee[:committee_listing].each do |c|
      c[:committee_type] = c.delete(:type)
      c[:committee_id] = c.delete(:id)
      c[:bill_id] = bill_detail[:id]
      BillsCommittee.find_or_create_by(bill_id: bill_detail[:id], committee_type: c[:committee_type]).update(c)
    end
  else
    LOG.info("No committee assignments")
  end
  sleep 2
end
