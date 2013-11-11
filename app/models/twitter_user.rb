class TwitterUser < ActiveRecord::Base
  attr_accessible :twitter_user

  serialize :twitter_user

end
