namespace :mongo_rates do
  namespace :db do

    desc "Create mongo_rates indexes"
    task :index => [:environment, :deindex] do
      MongoRates::Models::Person.ensure_index          :person_type,    :background => true
      MongoRates::Models::Person.ensure_index          :person_id,      :background => true

      MongoRates::Models::Rating.ensure_index          :person_id,      :background => true
      MongoRates::Models::Rating.ensure_index          :rateable_type,  :background => true
      MongoRates::Models::Rating.ensure_index          :rateable_id,    :background => true

      MongoRates::Models::Recommendation.ensure_index  :person_id,      :background => true
      MongoRates::Models::Recommendation.ensure_index  :rateable_type,  :background => true
      MongoRates::Models::Recommendation.ensure_index  :rateable_id,    :background => true
    end

    #desc "Private, Removes old mongo_rates indexes"
    task :deindex => :environment do
      # If you find out an index is un-needed, you should add an appropriate Model.collection.drop_index here.
      # MongoMapper doesn't yet have an inverse of ensure_index, so you have to do it via the index name and Mongo driver.
    end

  end
end
