module Search
  class Base

    attr_accessor :adapter

    def initialize(adapter=nil)
      @adapter = adapter || default_adapter
    end

    def search(text)
      stripped = text.strip
      if Ticket.code?(stripped)
        Result.new(Ticket.includes(:order).find_by_code(stripped))
      elsif Order.page_code?(stripped)
        Result.new(Ticket.get_page(stripped))
      else
        adapter.find_by_text(stripped)
      end
    end

    protected

      def default_adapter
        Adapters::Mysql.new(Order.connection)
      end

  end
end
