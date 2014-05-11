class RemoveEmailIndex < ActiveRecord::Migration
  def change
  	remove_index :users, :email
  	remove_column :users, :my_account_id 
  	 end
end
