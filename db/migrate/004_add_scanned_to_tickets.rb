class AddScannedToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :scanned, :boolean, :default => false
  end
end
