#!/bin/bash -l

env > /home/john/environment.txt
rvm 2.1.0@gga
ruby ~/gga-services/bin/load_session_bills.rb
ruby ~/gga-services/bin/load_votes.rb
ruby ~/gga-services/bin/legislative_day_scraper.rb

