class Search
  
  attr_accessor :connection

  def initialize(connection=Orders.connection)
    @connection = connection
  end

  #def retrieve_orders_by_text
  def find_by_text(text)
    orders  = find_orders(text)
    tickets = find_orders_by_tickets(text)

    # Clumsily interleave results.
    orders.zip(tickets).flatten.compact
  end

  def find_orders(text)
    # http://stackoverflow.com/questions/1241602/mysql-match-across-multiple-tables
    orders = Order.where("MATCH(full_name, email) AGAINST (? IN NATURAL LANGUAGE MODE)", text)
    tickets = Ticket.where("MATCH(full_name) AGAINST (? IN NATURAL LANGUAGE MODE)", text)
    orders.zip(tickets).flatten.compact
  end

end
