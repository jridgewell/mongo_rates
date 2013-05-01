require 'active_record'

ActiveRecord::Base.send :include, MongoRates::Rater
ActiveRecord::Base.send :include, MongoRates::Rateable
