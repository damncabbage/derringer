class Scan < CouchRest::Model::Base
  unique_id :id

  property :order_id, Integer
  property :order_code, String
  property :ticket_id, Integer
  property :ticket_code, String
  property :booth, String

  # One half of the timestamps! macro
  property :created_at, Time, :read_only => true, :protected => true, :auto_validation => false
  set_callback :save, :before do |object|
    write_attribute(:created_at, Time.now)
  end

  design do
    view :by_ticket_code
    view :by_order_code
  end

end
