require 'rubygems'
require 'data_mapper'
require 'dm-core'
require 'dm-migrations'

#DataMapper::Logger.new($stdout, :debug)
DataMapper::Property::String.length(255)
database_url = 'sqlite://'+File.dirname($PROGRAM_NAME)+'/quiz.db';
DataMapper.setup(:default, database_url)

require_relative 'quiz'

DataMapper.auto_upgrade!