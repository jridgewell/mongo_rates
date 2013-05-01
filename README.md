# MongoRates

Ratings and Recommendations using MongoDB

## Installation

Add this line to your application's Gemfile:

    gem 'mongo_rates'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongo_rates

## Usage

Inside your person (user|alien|etc...) add

    rates :tracks

This will allow you to `rate Track.first, 10`, and get `recommended
:tracks`.
This will also include

    rating(person)
    ratings
    average_rating
    rated?
    persons_rating

to whatever you're rating.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
