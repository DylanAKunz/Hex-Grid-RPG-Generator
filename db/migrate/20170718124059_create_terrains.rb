class CreateTerrains < ActiveRecord::Migration[5.1]
  def change
    create_table :terrains do |t|
      t.string :terrain
      t.string :generation_type
      t.string :color
      t.string :hover

      t.timestamps
    end
  end
end
