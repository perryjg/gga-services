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

