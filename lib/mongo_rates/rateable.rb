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
        return 0 if ratings.empty?

        map = %Q(function() {
          if (this.rateable_type == '#{self.class.to_s}' && this.rateable_id == #{id}) {
            emit(this.rateable_id, this.value);
          }
        })
        reduce = %Q(function(id, values) {
          return Array.sum(values) / values.length;
        })
        output_collection = "mongo_rates.models.ratings.#{self.class.to_s.downcase}#{id}"

        ratings.collection.map_reduce(map, reduce, :out => output_collection).find().first()['value']
      end

      def rated?
        !ratings.empty?
      end

      def persons_rating(person)
        person = MongoRates::Models::PersonRating.find_person(person)
        return nil unless person

        rating = ratings.first(:person_rating_id => person.id)
        rating.value if rating
      end
    end
  end
end
