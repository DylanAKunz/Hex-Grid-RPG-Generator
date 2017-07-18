class CreateTiles < ActiveRecord::Migration[5.1]
  def change
    create_table :tiles do |t|
      t.integer :x
      t.integer :y
      t.string :name
      t.string :terrain
      t.string :affinity
      t.integer :height
      t.integer :threat

      t.timestamps
    end
  end
end
