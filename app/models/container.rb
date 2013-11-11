class Container < ActiveRecord::Base
  belongs_to :collection
  belongs_to :albumize, :polymorphic => true
end
