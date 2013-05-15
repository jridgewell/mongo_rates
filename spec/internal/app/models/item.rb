class Item < ActiveRecord::Base
  attr_accessible :name

  # Make public for testing, usually private
  def ratings_query
    super
  end
end
