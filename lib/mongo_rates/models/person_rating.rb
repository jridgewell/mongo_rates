require 'mongo_mapper'

module MongoRates
  module Models
    class PersonRating
      include MongoMapper::Document

      belongs_to :person, :polymorphic => true, :required => true
      many :ratings, :class_name => 'MongoRates::Models::Rating'
      many :recommendations, :class_name => 'MongoRates::Models::Recommendation'

      def self.find_person_with_hash(person_hash, options = {})
        person = first(person_hash)
        return person unless options[:create]

        person = create(person_hash) if person.nil?
        person
      end

      def self.find_person(person, options = {})
        return person if person.class == self
        find_person_with_hash person_to_query(person), options
      end

      def self.find_person!(person)
        find_person person, :create => true
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
