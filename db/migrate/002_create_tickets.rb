class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets, :options => "ENGINE=MyISAM" do |t|
      t.integer  "order_id"
      t.integer  "ticket_type_id"
      t.string   "code"
      t.string   "full_name"
      t.string   "age"
      t.string   "gender"
      t.string   "postcode"
      t.timestamps
    end
    execute "CREATE FULLTEXT INDEX fulltext_tickets ON tickets (full_name)"
  end
end
