class CreateAffinities < ActiveRecord::Migration[5.1]
  def change
    create_table :affinities do |t|
      t.string :affinity

      t.timestamps
    end
  end
end
