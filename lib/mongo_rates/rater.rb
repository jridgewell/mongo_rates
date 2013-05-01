require 'active_support/concern'

module MongoRates
  module Rater
    extend ActiveSupport::Concern

    module ClassMethods
      def recommends(*rateables)
        rateables.each do |rateable|
          MongoRates.to_class_string(rateable).constantize.send :include, MongoRates::Rateable::RateableMethods
        end
        self.send :include, RaterMethods
      end
    end

    module RaterMethods
      def rate(rateable, value)
        person = MongoRates::Models::PersonRating.find_person!(self)
        rateable_query = MongoRates::Models::Rating.rateable_to_query(rateable)
        rating_query = rateable_query.merge({:person_rating_id => person.id})

        rating = MongoRates::Models::Rating.first_or_new(rating_query)
        rating.value = value
        rating.save
      end

      #TODO: Find similar users.
      #def similar(rater)
      #end

      def recommended(rateable)
        MongoRates::Models::Recommendation.for_person(self).of_type(rateable).sort(:value.desc).all.map do |recommendation|
          recommendation.rateable
        end
      end

      def update_recommendations
        MongoRates::MongoRates::Recommendation.update_recommendations(self)
      end
    end
  end
end
