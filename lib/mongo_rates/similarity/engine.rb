module MongoRates
  module Similarity
    class Engine
      def self.similarity_between(person, other, options = {})
        strategy = load_strategy options[:strategy]
        strategy.ratings_hash = MongoRates::Models::Rating.persons_ratings_to_hash(person, other)

        person_key = MongoRates.polymorphic_to_key( MongoRates::Models::Person.find_person person )
        other_key = MongoRates.polymorphic_to_key( MongoRates::Models::Person.find_person other )

        strategy.similarity_between(person_key, other_key)
      end

      protected

      def self.load_strategy(key)
        case key
        when :euclidean
          MongoRates::Similarity::EuclideanDistanceStrategy.new
        else
          MongoRates::Similarity::PearsonCorrelationStrategy.new
        end
      end
    end
  end
end
