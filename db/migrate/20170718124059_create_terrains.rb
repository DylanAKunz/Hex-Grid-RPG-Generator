class CreateTerrains < ActiveRecord::Migration[5.1]
  def change
    create_table :terrains do |t|
      t.string :terrain
      t.string :type
      t.integer :color
      t.integer :hover

      t.timestamps
    end
  end
end
