class AddAccountIdToBrainBox < ActiveRecord::Migration
  def change
  	add_column :brainboxes, :account_id, :integer
  end
end
