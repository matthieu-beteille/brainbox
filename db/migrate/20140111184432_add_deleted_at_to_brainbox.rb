class AddDeletedAtToBrainbox < ActiveRecord::Migration
  def change
    add_column :brainboxes, :deleted_at, :datetime
  end
end
