require 'mongo_mapper'

MongoMapper::Document.plugin(MongoRates::Rater)
MongoMapper::EmbeddedDocument.plugin(MongoRates::Rater)
