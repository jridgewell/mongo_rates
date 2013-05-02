require 'mongo_mapper'

module MongoRates
  module Models
    class Person
      include MongoMapper::Document

      belongs_to :person, :polymorphic => true, :required => true
      many :ratings, :class_name => 'MongoRates::Models::Rating', :dependent => :destroy
      many :recommendations, :class_name => 'MongoRates::Models::Recommendation', :dependent => :destroy

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
        type_name = MongoRates.to_class_string person
        { :person_type => type_name, :person_id => person.id }
      end

    end
  end
end
