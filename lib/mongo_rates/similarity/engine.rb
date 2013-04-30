module MongoRates
  module Similarity
    class Engine
      def self.similarity_between(person, other, options = {})
        strategy = load_strategy options[:strategy]
        strategy.ratings_hash = create_ratings_to_hash(person, other)

        person_key = MongoRates.polymorphic_to_key( MongoRates::Models::PersonRating.find_person person )
        other_key = MongoRates.polymorphic_to_key( MongoRates::Models::PersonRating.find_person other )

        strategy.similarity_between(person_key, other_key)
      end

      protected

      def self.create_ratings_to_hash(*persons)
        persons.flatten!

        return ratings_to_hash MongoRates::Models::Rating.all if persons.empty?

        hash = {}
        persons.each do |person|
          ratings = MongoRates::Models::Rating.by_person(person)
          hash.merge!(ratings_to_hash(ratings))
        end
        hash
      end

      def self.ratings_to_hash(ratings)
        hash = {}
        ratings.each do |rating|
          person_rating = rating.person_rating
          person_key = MongoRates.polymorphic_to_key(person_rating)
          hash[person_key] ||= {}

          rating_key = (rating.rateable_type + rating.rateable_id.to_s).to_sym
          hash[person_key][rating_key] = rating.value
        end
        hash
      end

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
