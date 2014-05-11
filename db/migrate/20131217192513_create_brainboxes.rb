class CreateBrainboxes < ActiveRecord::Migration
  def change
    create_table :brainboxes do |t|
      t.string :name
      t.string :descr

      t.timestamps
    end
  end
end
