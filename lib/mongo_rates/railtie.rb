require 'mongo_rates'
require 'rails'

module MongoRates
  class Railtie < Rails::Railtie
    railtie_name :mongo_rates

    rake_tasks do
      Dir[File.join(File.dirname(__FILE__), '..', 'tasks', '*.rake')].each { |f| load f }
    end
  end
end
