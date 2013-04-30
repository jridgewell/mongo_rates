require 'active_record'

ActiveRecord::Base.send :include, MongoRates::Models::Person
