# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140111184432) do

  create_table "accounts", force: true do |t|
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subscription_type"
  end

  create_table "brainboxes", force: true do |t|
    t.string   "name"
    t.string   "descr"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.datetime "deleted_at"
  end

  create_table "ideas", force: true do |t|
    t.string   "name"
    t.string   "content"
    t.integer  "brainbox_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "thumbs_up"
    t.integer  "thumbs_down"
    t.integer  "account_id"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.integer  "account_id"
    t.datetime "deleted_at"
  end

  add_index "users", ["email", "account_id"], name: "email_account_id_couple_index"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "votes", force: true do |t|
    t.boolean  "vote",          default: false, null: false
    t.integer  "voteable_id",                   null: false
    t.string   "voteable_type",                 null: false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], name: "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], name: "fk_one_vote_per_user_per_entity", unique: true
  add_index "votes", ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type"

end
