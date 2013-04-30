require 'rake'

namespace :mongo_rates do
  task :update_recommended, [:person, :id, :strategy] => :environment do |t, args|
    person, id = args[:person], args[:id]
    options = {}
    options[:strategy] = args[:strategy]
    person_to_update = nil
    if person && id
      person = person.to_s.classify.constantize
      person_to_update = person.find(id)
    end
    MongoRates::Models::Recommendation.update_recommendations person_to_update
  end
end
