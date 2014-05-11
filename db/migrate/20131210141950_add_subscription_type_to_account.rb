class AddSubscriptionTypeToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :subscription_type, :string
  end
end
