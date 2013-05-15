class User < ActiveRecord::Base
  attr_accessible :name
  rates :items
end
