module MongoRates
  module Similarity
    class EuclideanDistanceStrategy < BaseStrategy
      def similarity_between(person, other)
        shared = shared_items_between(person, other)

        return 0 if shared.empty?

        sum_of_squares = shared.reduce(0.0) { |sum, item|
          sum + (ratings_hash[person][item] - ratings_hash[other][item]) ** 2
        }

        1 / (1 + sum_of_squares)
      end
    end
  end
end

