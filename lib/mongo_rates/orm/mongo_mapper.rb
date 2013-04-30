require 'mongo_mapper'

MongoMapper::Document.plugin(MongoRates::Models::Person)
MongoMapper::EmbeddedDocument.plugin(MongoRates::Models::Person)
