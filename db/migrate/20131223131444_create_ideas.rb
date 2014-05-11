class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :name
      t.string :content
      t.integer :brainbox_id

      t.timestamps
    end
  end
end
