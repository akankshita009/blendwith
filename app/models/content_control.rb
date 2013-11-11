class ContentControl < ActiveRecord::Base
  belongs_to :user
  belongs_to :itemizable, polymorphic: true
  attr_accessible :access_level, :itemizable
end
