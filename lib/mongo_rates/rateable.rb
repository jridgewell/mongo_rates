require 'active_support/concern'

module MongoRates
  module Rateable
    extend ActiveSupport::Concern

    included do
      def ratings
        ratings_query = MongoRates::Models::Rating.rateable_to_query(self)
        MongoRates::Models::Rating.where(ratings_query)
      end

      def rating(person = nil)
        if person && (rating = persons_rating(person))
          rating
        else
          average_rating
        end
      end

      def average_rating
        rateable_ratings = ratings
        return 0 if ratings.empty?

        rateable_ratings.all.reduce(0.0) { |sum, rating|
          sum += rating.value
        } / rateable_ratings.size
      end

      def rated?
        !ratings.empty?
      end

      def persons_rating(person)
        person = MongoRates::Models::PersonRating.by_person(person)
        return nil unless person

        ratings.first(:person_rating_id => person.id)
      end
    end
  end
end
