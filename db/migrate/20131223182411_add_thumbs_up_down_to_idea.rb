class AddThumbsUpDownToIdea < ActiveRecord::Migration
  def change
  	add_column :ideas, :thumbs_up, :integer
  	add_column :ideas, :thumbs_down, :integer
  end
end
