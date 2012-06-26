class CreateTicketTypes < ActiveRecord::Migration
  def change
    create_table :ticket_types do |t|
      #t.references :event # TODO

      t.string :title
      t.decimal :price, :precision => 8, :scale => 2
      t.boolean :public, :default => true

      t.timestamps
    end
  end
end
