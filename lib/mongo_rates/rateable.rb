require 'active_support/concern'

module MongoRates
  module Rateable
    extend ActiveSupport::Concern

    module ClassMethods
      def rateable
        self.send :include, RateableMethods
      end
    end

    module RateableMethods
      case
      when  defined?(ActiveRecord::Base)            && ancestors.include?(ActiveRecord::Base),
            defined?(MongoMapper::Document)         && ancestors.include?(MongoMapper::Document),
            defined?(MongoMapper::EmbeddedDocument) && ancestors.include?(MongoMapper::EmbeddedDocument)
        before_destroy :destory_rateable
      end

      def rating(person = nil)
        if person && (rating = persons_rating(person))
          rating
        else
          average_rating
        end
      end

      def ratings
        ratings_query.all
      end

      def average_rating
        return 0 if ratings_query.empty?

        map = %Q(function() {
          if (this.rateable_type == '#{self.class.to_s}' && this.rateable_id == #{id}) {
            emit(this.rateable_id, this.value);
          }
        })
        reduce = %Q(function(id, values) {
          return Array.sum(values) / values.length;
        })
        output_collection = "mongo_rates.models.ratings.#{self.class.to_s.downcase}#{id}"

        ratings_query.collection.map_reduce(map, reduce, :out => output_collection).find().first()['value']
      end

      def rated?
        !ratings_query.empty?
      end

      def persons_rating(person)
        person = MongoRates::Models::Person.find_person(person)
        return nil unless person

        rating = ratings_query.first(:person_id => person.id)
        rating.value if rating
      end

      private
      def destory_rateable
        ratings_query.each do |rating|
          rating.destroy
        end
      end

      def ratings_query
        ratings_query = MongoRates::Models::Rating.rateable_to_query(self)
        MongoRates::Models::Rating.where(ratings_query)
      end
    end
  end
end
