module Search
  module Adapters
    class Mysql
  
      attr_accessor :connection

      def initialize(connection=Orders.connection)
        @connection = connection
      end

      #def retrieve_orders_by_text
      def find_by_text(text)
        find_orders(text)
      end

      def find_orders(text)
        # http://stackoverflow.com/questions/1241602/mysql-match-across-multiple-tables
        orders = Order.where("MATCH(code, full_name, email) AGAINST (? IN NATURAL LANGUAGE MODE)", text)
        tickets = Ticket.where("MATCH(full_name) AGAINST (? IN NATURAL LANGUAGE MODE)", text)
        orders.zip(tickets).flatten.compact
      end

    end
  end
end
