require 'mongo_mapper'

module MongoRates
  module Models
    class PersonRating
      include MongoMapper::Document

      belongs_to :person, :polymorphic => true, :required => true
      many :ratings, :class_name => 'MongoRates::Models::Rating'
      many :recommendations, :class_name => 'MongoRates::Models::Recommendation'

      def self.by_person_hash(person_hash)
        first(person_hash)
      end

      def self.by_person(person)
        return person if person.class == self
        by_person_hash person_to_query(person)
      end

      def self.by_person!(person)
        person_hash = person_to_query(person)
        by_person_hash(person_hash) || create(person_hash)
      end

      def self.person_to_query(person)
        { :person_type => person.class.to_s, :person_id => person.id }
      end

      def self.all_persons
        fields(:person_type, :person_id).all.map do |person|
          { :person_type => person.person_type, :person_id => person.person_id }
        end
      end
    end
  end
end
