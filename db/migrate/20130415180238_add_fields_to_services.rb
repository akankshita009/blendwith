class AddFieldsToServices < ActiveRecord::Migration
  def change
    add_column :services, :data, :text
  end
end
