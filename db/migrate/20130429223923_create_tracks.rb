class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :title
      t.text :track_object
      t.boolean :private

      t.timestamps
    end
  end
end
