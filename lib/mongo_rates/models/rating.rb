require 'mongo_mapper'

module MongoRates
  module Models
    class Rating
      include MongoMapper::Document

      belongs_to :person, :class_name => 'MongoRates::Models::Person', :required => true
      belongs_to :rateable, :polymorphic => true, :required => true
      key :value, Integer, :numeric => true

      scope :of_type, lambda { |type|
        return self.query unless type
        type_name = MongoRates.to_class_string type
        where(:rateable_type => type_name)
      }

      scope :by_person, lambda { |person|
        return self.query unless person
        person = MongoRates::Models::Person.find_person!(person)
        where(:person_id => person.id)
      }

      def self.rateable_to_query(rateable)
        type_name = MongoRates.to_class_string rateable
        { :rateable_type => type_name, :rateable_id => rateable.id}
      end

      def self.persons_ratings_to_hash(*persons)
        persons.flatten!

        return ratings_to_hash MongoRates::Models::Rating.all if persons.empty?

        hash = {}
        persons.each do |person|
          ratings = MongoRates::Models::Rating.by_person(person)
          hash.merge!(ratings_to_hash(ratings))
        end
        hash
      end

      protected

      def self.ratings_to_hash(ratings)
        hash = {}
        ratings.each do |rating|
          person = rating.person
          person_key = MongoRates.polymorphic_to_key(person)
          hash[person_key] ||= {}

          rating_key = (rating.rateable_type + rating.rateable_id.to_s).to_sym
          hash[person_key][rating_key] = rating.value
        end
        hash
      end

    end
  end
end
