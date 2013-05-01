require 'active_support/concern'

module MongoRates
  module Rater
    extend ActiveSupport::Concern

    module ClassMethods
      def rates(*rateables)
        rateables.each do |rateable|
          MongoRates.to_class_string(rateable).constantize.send :include, MongoRates::Rateable::RateableMethods
        end
        self.send :include, RaterMethods
      end
    end

    module RaterMethods
      case
      when  defined?(ActiveRecord::Base)            && ancestors.include?(ActiveRecord::Base),
            defined?(MongoMapper::Document)         && ancestors.include?(MongoMapper::Document),
            defined?(MongoMapper::EmbeddedDocument) && ancestors.include?(MongoMapper::EmbeddedDocument)
        before_destroy :destory_person
      end

      def rate(rateable, value)
        person = MongoRates::Models::PersonRating.find_person!(self)
        rateable_query = MongoRates::Models::Rating.rateable_to_query(rateable)
        rating_query = rateable_query.merge({:person_rating_id => person.id})

        rating = MongoRates::Models::Rating.first_or_new(rating_query)
        if value > 0
          rating.value = value
          rating.save
        else
          rating.destroy
        end
        true
      end

      #TODO: Find similar users.
      #def similar(rater)
      #end

      def recommended(rateable = nil)
        MongoRates::Models::Recommendation.for_person(self).of_type(rateable).sort(:value.desc).all.map do |recommendation|
          recommendation.rateable
        end
      end

      def update_recommendations(options = {})
        MongoRates::Models::Recommendation.update_recommendations self, options
      end

      private
      def destory_person
        person = MongoRates::Models::PersonRating.find_person(self)
        person.destroy if person
      end
    end
  end
end
