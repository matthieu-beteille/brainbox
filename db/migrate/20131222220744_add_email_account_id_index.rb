class AddEmailAccountIdIndex < ActiveRecord::Migration
  def change
  	  add_index "users", [:email, :account_id], name: "email_account_id_couple_index" #, unique: true
  end
end
