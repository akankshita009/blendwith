class AddNoNeedConfirmToUser < ActiveRecord::Migration
  def change
    add_column :users, :no_need_confirm, :boolean, :default => true
  end
end
