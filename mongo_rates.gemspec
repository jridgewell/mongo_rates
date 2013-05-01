# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongo_rates/version'

Gem::Specification.new do |spec|
  spec.name          = "mongo_rates"
  spec.version       = MongoRates::VERSION
  spec.authors       = ["Justin Ridgewell"]
  spec.email         = ["justin@ridgewell.name"]
  spec.description   = %q{Ratings and Recommendations using MongoDB}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails"
  spec.add_dependency "mongo_mapper"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
