require 'mongo_mapper'

module MongoRates
  module Models
    class Recommendation
      include MongoMapper::Document

      belongs_to :person_rating, :class_name => 'MongoRates::Models::PersonRating', :required => true
      belongs_to :rateable, :polymorphic => true, :required => true
      key :value, Integer, :numeric => true

      def self.of_type(type)
        where(:rateable_type => type.to_s.classify) unless type.nil?
      end

      def self.for_person(person)
        person = MongoRates::Models::PersonRating.by_person!(person)
        where(:person_rating_id => person.id)
      end

      def self.update_recommendations(person = nil, options = {})
        everyone = MongoRates::Models::PersonRating.all
        persons_to_update = if person
                              [MongoRates::Models::PersonRating.by_person(person)]
                            else
                              everyone
                            end
        ratings = MongoRates::Similarity::Engine.create_ratings_to_hash

        persons_to_update.each do |person|
          person_key = MongoRates.polymorphic_to_key(person)
          predicted_ratings_for_user = {}
          everyone.each do |other|
            next if person == other
            other_key = MongoRates.polymorphic_to_key(other)

            similarity = MongoRates::Similarity::Engine.similarity_between(person, other, options)
            next if similarity == 0

            ratings[other_key].each do |item, value|
              unless ratings[person_key].keys.include?(item)
                predicted_ratings_for_user[item] ||= { :total_similarity => 0.0, :weighted_mean => 0.0 }
                predicted_ratings_for_user[item][:total_similarity] += similarity
                predicted_ratings_for_user[item][:weighted_mean] += value * similarity
              end
            end
          end

          guessed_rating_and_query = Proc.new do |item, item_data|
            query_match = item.to_s.match(/(\w+)(\d+)/)
            {
              :value => item_data[:weighted_mean] / item_data[:total_similarity],
              :query => {
                :rateable_type => query_match[1],
                :rateable_id => query_match[2]
              }
            }
          end

          top = predicted_ratings_for_user.map(&guessed_rating_and_query).sort(&:first).reverse

          top.each do |value_query|
            query = { :person_rating_id => person.id }
            query.merge! value_query[:query]
            recommendation = first_or_new query
            recommendation.value = value_query[:value].to_i
            recommendation.save
          end
        end
      end

    end
  end
end
