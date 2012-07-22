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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 4) do

  create_table "orders", :force => true do |t|
    t.string   "code"
    t.integer  "bpay_crn"
    t.string   "status"
    t.string   "email"
    t.string   "full_name"
    t.string   "phone"
    t.text     "address"
    t.string   "state"
    t.string   "postcode"
    t.integer  "underage_tickets"
    t.integer  "tickets_count"
    t.datetime "fully_paid_at"
    t.datetime "received_ticket_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "orders", ["bpay_crn"], :name => "index_orders_on_bpay_crn"
  add_index "orders", ["code"], :name => "index_orders_on_code"
  add_index "orders", ["email"], :name => "index_orders_on_email"
  add_index "orders", ["full_name"], :name => "fulltext_orders"

  create_table "ticket_types", :force => true do |t|
    t.string   "title"
    t.decimal  "price",      :precision => 8, :scale => 2
    t.boolean  "public",                                   :default => true
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "tickets", :force => true do |t|
    t.integer  "order_id"
    t.integer  "ticket_type_id"
    t.string   "code"
    t.string   "full_name"
    t.string   "age"
    t.string   "gender"
    t.string   "postcode"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "scanned",        :default => false
  end

  add_index "tickets", ["full_name"], :name => "fulltext_tickets"

end
