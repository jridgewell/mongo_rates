require 'mongo_mapper'

module MongoRates
  module Models
    class Rating
      include MongoMapper::Document

      belongs_to :person_rating, :class_name => 'MongoRates::Models::PersonRating', :required => true
      belongs_to :rateable, :polymorphic => true, :required => true
      key :value, Integer, :numeric => true

      def self.of_type(type)
        where(:rateable_type => type.to_s.classify) unless type.nil?
      end

      def self.by_person(person)
        person = if person.class == MongoRates::Models::PersonRating
                   person
                 else
                   MongoRates::Models::PersonRating.by_person(person)
                 end
        where(:person_rating_id => person.id) if person
      end

      def self.rateable_to_query(rateable)
        { :rateable_type => rateable.class.to_s, :rateable_id => rateable.id}
      end

      def self.group_by_person(options = {})
        options[:out] = 'mongo_rates.models.ratings.by_person' unless options[:out]
        map = %Q(function() {
          var columns = {},
              key = this.rateable_type + this.rateable_id;
          columns[key] = this.value;
          emit(this.person_rating_id, columns);
        })

        reduce = %Q(function(id, values) {
          var vals = {};
          values.forEach(function(val, index) {
            for (var rateable in val) {
              vals[rateable] = val[rateable];
              break; // Since their's only one key in each object
            }
          });
          return vals;
        })

        collection.map_reduce(map, reduce, options).find()
      end
    end
  end
end
