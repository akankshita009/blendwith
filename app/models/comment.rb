class Comment < ActiveRecord::Base
  opinio

  has_many :comments,
           :class_name => 'Comment',
           :as => :commentable,
           :order => "created_at #{Opinio.sort_order}",
           :dependent => :destroy
  #belongs_to :user, :class_name => "User", :foreign_key => "owner_id"

end
