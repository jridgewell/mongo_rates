module MongoRates
  module Similarity
    class PearsonCorrelationStrategy < BaseStrategy
      def similarity_between(person, other)
        shared         = shared_items_between(person, other)
        ratings_person = ratings_hash[person]
        ratings_other  = ratings_hash[other]

        return 0 if shared.empty?

        sum_ratings_person = 0.0
        sum_ratings_other  = 0.0
        sum_squares_person = 0.0
        sum_squares_other  = 0.0
        product_sum        = 0.0
        number_shared      = shared.size

        shared.each { |item|
          sum_ratings_person += ratings_person[item]
          sum_ratings_other  += ratings_other[item]
          sum_squares_person += ratings_person[item] ** 2
          sum_squares_other  += ratings_other[item] ** 2
          product_sum        += ratings_person[item] * ratings_other[item]
        }

        numerator   = product_sum - (sum_ratings_person * sum_ratings_other / number_shared)
        den_person  = sum_squares_person - (sum_ratings_person ** 2) / number_shared
        den_other   = sum_squares_other - (sum_ratings_other ** 2) / number_shared
        denominator = Math.sqrt(den_person * den_other)

        return 0 if denominator == 0
        numerator / denominator
      end
    end
  end
end
