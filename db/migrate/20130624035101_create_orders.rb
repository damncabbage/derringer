class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders, :options => "ENGINE=MyISAM" do |t|
      t.string   "code"
      t.integer  "bpay_crn"
      t.string   "status"
      t.string   "email"
      t.string   "full_name"
      t.string   "phone"
      t.text     "address"
      t.string   "state"
      t.string   "postcode"
      t.integer  "tickets_count"
      t.datetime "fully_paid_at"
      t.datetime "received_ticket_at"
      t.timestamps
    end
    execute "CREATE FULLTEXT INDEX fulltext_orders ON orders (full_name)"
    add_index :orders, :email
    add_index :orders, :code
    add_index :orders, :bpay_crn
  end
end
