require 'rubygems'
require 'savon'
require 'logger'
require_relative 'services/legislative_session'
require_relative 'services/member'
require_relative 'services/committee'
# require_relative 'services/legislation_summary'
require_relative 'services/legislation'
require_relative 'services/legislation_text'
require_relative 'services/vote'

module GGAServices
  logger = Logger.new(STDERR)
  logger.level = Logger::DEBUG
end
