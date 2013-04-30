module MongoRates
  module Similarity
    class BaseStrategy
      attr_accessor :ratings_hash

      def similarity_between(person, other)
        raise "The #similarity_between was not implemented in #{self.class}"
      end

      protected

      def shared_items_between(person, other)
        return [] unless ratings_hash[person] && ratings_hash[other]

        ratings_hash[person].keys.select { |key|
          ratings_hash[other].keys.include? key
        }
      end
    end
  end
end
