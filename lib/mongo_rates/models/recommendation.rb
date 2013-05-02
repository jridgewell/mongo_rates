require 'mongo_mapper'

module MongoRates
  module Models
    class Recommendation
      include MongoMapper::Document

      belongs_to :person, :class_name => 'MongoRates::Models::Person', :required => true
      belongs_to :rateable, :polymorphic => true, :required => true
      key :value, Integer, :numeric => true

      scope :of_type, lambda { |type|
        return self.query unless type
        type_name = MongoRates.to_class_string type
        where(:rateable_type => type_name)
      }

      scope :for_person, lambda { |person|
        return self.query unless person
        person = MongoRates::Models::Person.find_person!(person)
        where(:person_id => person.id)
      }


      def self.update_recommendations(person = nil, options = {})
        everyone = MongoRates::Models::Person.all
        persons_to_update = if person
                              [MongoRates::Models::Person.find_person!(person)]
                            else
                              everyone
                            end
        ratings = MongoRates::Models::Rating.persons_ratings_to_hash

        persons_to_update.each do |person|
          for_person(person).each do |recommendation|
            recommendation.destroy
          end
          person_key = MongoRates.polymorphic_to_key(person)
          predicted_ratings_for_user = {}

          everyone.each do |other|
            next if person == other
            other_key = MongoRates.polymorphic_to_key(other)

            similarity = MongoRates::Similarity::Engine.similarity_between(person, other, options)
            next if similarity == 0

            ratings[other_key].each do |item, value|
              unless ratings[person_key][item]
                predicted_ratings_for_user[item] ||= { :total_similarity => 0.0, :weighted_mean => 0.0 }
                predicted_ratings_for_user[item][:total_similarity] += similarity
                predicted_ratings_for_user[item][:weighted_mean] += value * similarity
              end
            end
          end

          to_value_and_query = Proc.new do |item, item_data|
            query_match = item.to_s.match(/(\D+)(\d+)/)
            {
              :value => item_data[:weighted_mean] / item_data[:total_similarity],
              :query => {
                :rateable_type => query_match[1],
                :rateable_id => query_match[2]
              }
            }
          end

          predicted_ratings_for_user.map(&to_value_and_query).each do |value_query|
            new(value_query.query).tap { |recommendation|
              recommendation.person_id = person.id
              recommendation.value = value_query[:value].to_i
            }.save
          end
        end
      end

    end
  end
end
