require 'active_support'

require 'mongo_rates/version'

module MongoRates
  autoload :Rater, 'mongo_rates/rater'
  autoload :Rateable, 'mongo_rates/rateable'

  module Models
    autoload :PersonRating, 'mongo_rates/models/person_rating'
    autoload :Rating, 'mongo_rates/models/rating'
    autoload :Recommendation, 'mongo_rates/models/recommendation'
  end

  module Similarity
    autoload :BaseStrategy, 'mongo_rates/similarity/base_strategy'
    autoload :EuclideanDistanceStrategy, 'mongo_rates/similarity/euclidean_distance_strategy'
    autoload :PearsonCorrelationStrategy, 'mongo_rates/similarity/pearson_correlation_strategy'
    autoload :Engine, 'mongo_rates/similarity/engine'
  end

  def self.to_class_string(obj)
    obj.to_s.gsub(/^#<(\w+):0x[0-9a-f]+>$/,'\1').classify
  end

  def self.polymorphic_to_key(poly)
    regex = /(.+)_type/
    poly_name = nil
    poly.attributes.each do |key, value|
      if key =~ regex
        poly_name = $1
        break;
      end
    end

    return nil unless poly_name

    poly_type = poly_name + '_type'
    poly_id = poly_name + '_id'
    (poly[poly_type].to_s + poly[poly_id].to_s).to_sym
  end

end

if defined?(Rails)
  require 'mongo_rates/railtie'
  require 'mongo_rates/orm/mongo_mapper'    if defined?(MongoMapper::Document)
  require 'mongo_rates/orm/active_record'	  if defined?(ActiveRecord::Base)
end
