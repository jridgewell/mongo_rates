require 'rubygems'
require 'bundler/setup'

require 'combustion'
Combustion.initialize! :active_record

require 'mongo_mapper'
require 'mongo_rates'

require 'rspec/rails'
require 'factory_girl_rails'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end

MongoMapper.connection = Mongo::MongoClient.new('127.0.0.1', 27017)
MongoMapper.database = "test"
MongoMapper.database.collections.each { |c| c.drop_indexes }
