class AddAcountIdToIdea < ActiveRecord::Migration
  def change
  	add_column :ideas, :account_id, :integer
  end
end
