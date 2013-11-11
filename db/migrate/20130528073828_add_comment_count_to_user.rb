class AddCommentCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :comment_count, :integer, default: 0
  end
end
