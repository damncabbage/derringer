module Search
  module Adapters
    class Mysql
 
      attr_accessor :connection

      def initialize(connection=Orders.connection)
        @connection = connection
      end

      def find_by_text(text)
        orders = find_orders(text)
        return orders
        # TODO
        tickets = find_tickets(text)
        orders.zip(tickets.map(&:order)).flatten.compact
      end

      def find_orders(text)
        # http://stackoverflow.com/questions/1241602/mysql-match-across-multiple-tables
        orders = Order.includes(:tickets).limit(40).where("
          orders.code = ?
          OR orders.email LIKE ?
          OR orders.bpay_crn = ?
          OR (
            MATCH(orders.full_name) AGAINST (? IN NATURAL LANGUAGE MODE)
          )
          OR tickets.full_name LIKE ?
        ", text, "#{text}%", text, text, "#{text}%").map do |order|
          ::Search::Result.new(order.tickets)
        end
      end

      def find_tickets(text)
        tickets = Ticket.where("
          MATCH(tickets.full_name) AGAINST (? IN NATURAL LANGUAGE MODE)
        ", text)
      end

    end
  end
end
