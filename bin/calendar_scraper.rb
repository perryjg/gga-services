require 'watir-webdriver'
require 'digest'
require 'logger'
require 'active_record'
require 'mysql2'
require 'date'

LOG = Logger.new('logs/calendar_scrape.log');
LOG.level = Logger::INFO
LOG.info('START')

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: ENV["GGA_HOST"],
  username: ENV["GGA_USER"],
  password: ENV["GGA_PASSWORD"],
  database: "gga_staging"
)

class CommitteeMeeting < ActiveRecord::Base
  self.primary_key = "id"
end

b = Watir::Browser.new :phantomjs
# b = Watir::Browser.new

begin
  ['house','senate'].each do |chamber|
    LOG.info( "going to calendar page for #{chamber}" )
    b.goto "http://calendar.legis.ga.gov/Calendar/?chamber=#{chamber}"

    # (1..11).each {|x| b.link(title: "Go to the previous month").click}
    b.link(title: "Go to the previous month").click
    (1..4).each do |i|
      month = b.table(id: "Calendar1")
      LOG.info( month.rows[0].cells[2].text )

      sundays = []
      weeks = month.rows[2..7]
      weeks.each do |week|
        sunday = week.cells[0]
        title = sunday.a.attribute_value("title")
        sundays << title
      end

      sundays.each do |sunday|
        LOG.info( "Week of #{sunday}" )
        b.link(title: sunday).click
        meetings = b.links(class: "cssSubjectLink").map {|m| m.text}
        LOG.info("#{meetings.length} meetings found")
        meetings.each do |m|
          b.link(text: m).click
          meeting = {}
          meeting[:chamber] = chamber
          meeting[:url] = b.url
          meeting[:title] = b.div(class: "cssDetailSubject").text
          meeting[:date_text] = b.div(class: "cssDateLabel").text

          date = DateTime.strptime(meeting[:date_text], '%A, %B %d, %Y')
          meeting[:ajc_date] = date.strftime('%Y-%m-%d')

          value_keys = b.spans(class: "cssDetailMeetingLabel").map {|a| a.text.downcase!.gsub!(/:/, '')}
          meeting_values = b.spans(class: "cssDetailMeetingValue").to_a
          meeting_values.each do |value|
            meeting[ value_keys[ meeting_values.index(value) ].to_sym ] = value.text
          end
          meeting[:canceled] = meeting[:location].match(/CANCELED/) ? 1 : 0
          meeting[:content] = b.div(class: "cssDetailBody").html

          meeting[:agenda_link] = b.link(text: 'AGENDA').exists? ? # house calendar site
             b.link(text: 'AGENDA').attribute_value("href") :
             b.link(text: 'Agenda').exists? ? # senate calendar site
               b.link(text: 'Agenda').attribute_value("href") :
               ''

          meeting[:id] = Digest::SHA1.hexdigest meeting[:url]
          LOG.debug( "Title: #{meeting[:title]}" )
          LOG.debug( "Location: #{meeting[:location]}" )
          LOG.debug( "Time: #{meeting[:time]}" )
          LOG.debug( "Date: #{meeting[:ajc_date]}" )
          LOG.debug( "Agenda link: #{meeting[:agenda_link]}" )
          LOG.debug( "Canceled: #{meeting[:canceled]}" )

          CommitteeMeeting.find_or_initialize_by(id: meeting[:id]).update(meeting)

          sleep 1
          b.back
        end
        sleep 1
      end
      b.link(title: "Go to the next month").click
    end
  end

rescue Exception => e
  puts "ERROR"
  puts e.message
  puts e.backtrace.inspect
  b.close
end

b.close
