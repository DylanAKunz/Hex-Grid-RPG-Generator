class CreateGrids < ActiveRecord::Migration[5.1]
  def change
    create_table :grids do |t|
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end
end
