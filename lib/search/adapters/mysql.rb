module Search
  module Adapters
    class Mysql
  
      attr_accessor :connection

      def initialize(connection=Orders.connection)
        @connection = connection
      end

      #def retrieve_orders_by_text
      def find_by_text(text)
        orders = find_orders(text)
        return orders
        # TODO
        tickets = find_tickets(text)
        orders.zip(tickets.map(&:order)).flatten.compact
      end

      def find_orders(text)
        # http://stackoverflow.com/questions/1241602/mysql-match-across-multiple-tables
        orders = Order.includes(:tickets).paid.where("
          MATCH(orders.full_name) AGAINST (? IN NATURAL LANGUAGE MODE)
          OR orders.code = ?
          OR orders.email LIKE ?
          OR orders.bpay_crn = ?
        ", text, text, "#{text}%", text)
      end

      def find_tickets(text)
        tickets = Ticket.paid.where("
          MATCH(tickets.full_name) AGAINST (? IN NATURAL LANGUAGE MODE)
        ", text)
      end

    end
  end
end
