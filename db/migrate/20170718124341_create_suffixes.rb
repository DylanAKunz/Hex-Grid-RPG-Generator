class CreateSuffixes < ActiveRecord::Migration[5.1]
  def change
    create_table :suffixes do |t|
      t.string :suffix

      t.timestamps
    end
  end
end
