# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongo_rates/version'

Gem::Specification.new do |spec|
  spec.name          = "mongo_rates"
  spec.version       = MongoRates::VERSION
  spec.authors       = ["Justin Ridgewell"]
  spec.email         = ["justin@ridgewell.name"]
  spec.summary       = %q{Ratings and Recommendations using MongoDB}
  spec.homepage      = %q{https://github.com/jridgewell/mongo_rates}
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 3.2"
  spec.add_dependency "mongo_mapper", "~> 0.12.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sqlite3", "~> 1.3.7"
  spec.add_development_dependency "combustion", "~> 0.5.0"
  spec.add_development_dependency "factory_girl_rails", "~> 2.0"
  spec.add_development_dependency "rspec-rails", "~> 2.0"
end
