class CreateContentControls < ActiveRecord::Migration
  def change
    create_table :content_controls do |t|
      t.references :user
      t.references :itemizable, polymorphic: true
    end
    add_index :content_controls, :user_id
    add_index :content_controls, [:itemizable_id, :itemizable_type], name: 'content_control_itemizable'
  end
end
