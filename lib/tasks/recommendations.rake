require 'rake'

namespace :mongo_rates do
  desc 'Update Recommendations.'
  task :recommendations, [:person, :id, :strategy] => :environment do |t, args|
    options = {}
    options[:strategy] = args[:strategy].to_sym if args[:strategy]

    person_to_update = nil
    if args[:person] && args[:id]
      person = MongoRates.to_class_string(args[:person]).constantize
      person_to_update = person.find(args[:id])
    end
    MongoRates::Models::Recommendation.update_recommendations person_to_update, options
  end
end
