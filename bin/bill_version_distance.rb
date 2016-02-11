require 'rtf_parse'
require 'active_record'
require 'mysql2'
require 'levenshtein'
require 'logger'

LOG = Logger.new('logs/version_distance.log', 'weekly')
LOG.level = Logger::INFO
LOG.info('START')


def clean(text)
  text.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  text.gsub!(/\[-.*?-\]/, '')
  text.gsub!(/\[\+/, '')
  text.gsub!(/\+\]/, '')
  text.gsub!(/\n/, ' ')
  text.gsub!(/ +/, ' ')
  return text
end

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: ENV["GGA_HOST"],
  username: ENV["GGA_USER"],
  password: ENV["GGA_PASSWORD"],
  database: "gga_staging"
)

class Text < ActiveRecord::Base
  self.table_name = "bills_text"
  self.primary_key = "version_id"
end

class Bill < ActiveRecord::Base
  has_many :versions
  scope :current, -> {where(session_id: 24)}
end

class Version < ActiveRecord::Base
  belongs_to :bill
  self.primary_key = "id"
end

config_path = File.expand_path(File.dirname(__FILE__) + '/../config')
bills = Bill.current
bills.each do |bill|
  versions = bill.versions.order(:version).to_a
  if versions.length > 1
    LOG.debug( bill.id )
    LOG.debug( "version count: #{versions.length}" )
    LOG.debug( versions )
    (1..versions.length - 1).each do |i|
      if versions[i].nil?
        LOG.info("Version index #{i} nil")
        next
      end

      next unless versions[i].distance.nil?
      v1_record = Text.where({bill_id: bill.id, version_id: versions[i].id}).first
      v0_record = Text.where({bill_id: bill.id, version_id: versions[i-1].id}).first
      if v1_record.nil? or v0_record.nil? or v1_record.text.nil? or v0_record.text.nil?
        LOG.info("Null text for version #{versions[i].id} or #{versions[i-1].id}")
        next
      end
      v1 = clean(RtfParse.custom_parse(v1_record.text, tags_file: 'legis', config_path: config_path))
      v0 = clean(RtfParse.custom_parse(v0_record.text, tags_file: 'legis', config_path: config_path))
      d = Levenshtein.distance(v1, v0) / [v1.length, v0.length].max.to_f

      versions[i].distance = d
      LOG.info( "Distance calculated for version #{versions[i].id}: #{versions[i].distance}" )
      versions[i].save
    end
  else
    LOG.debug( bill.id )
    LOG.debug( "version count: #{versions.length}" )
  end
end
LOG.info('STOP')