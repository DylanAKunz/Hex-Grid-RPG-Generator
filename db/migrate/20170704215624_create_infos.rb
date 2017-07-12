class CreateInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :infos do |t|
      t.integer :grid
      t.string :terrain
      t.string :name
      t.string :note
      t.string :type
      t.integer :difficulty

      t.timestamps
    end
  end
end
