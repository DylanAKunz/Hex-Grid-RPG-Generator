class CreatePrefixes < ActiveRecord::Migration[5.1]
  def change
    create_table :prefixes do |t|
      t.string :prefix

      t.timestamps
    end
  end
end
