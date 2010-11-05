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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101105220520) do

  create_table "commitments", :force => true do |t|
    t.decimal  "amount",     :precision => 12, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deal_id"
    t.integer  "user_id"
  end

  create_table "deals", :force => true do |t|
    t.string   "startup_name"
    t.string   "website"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "logo_url"
    t.decimal  "required_amount",    :precision => 10, :scale => 2
    t.decimal  "proposed_valuation", :precision => 12, :scale => 2
    t.datetime "closing_date"
    t.string   "round"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "invitations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "deal_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "budget"
    t.string   "nickname"
  end

end
