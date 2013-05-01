require 'mongo_mapper'

MongoMapper::Document.plugin(MongoRates::Rater)
MongoMapper::EmbeddedDocument.plugin(MongoRates::Rater)
MongoMapper::Document.plugin(MongoRates::Rateable)
MongoMapper::EmbeddedDocument.plugin(MongoRates::Rateable)
