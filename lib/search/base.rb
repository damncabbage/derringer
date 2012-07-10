module Search
  class Base

    attr_accessor :adapter

    def initialize(adapter=nil)
      @adapter = adapter || default_adapter
    end

    def search(text)
      stripped = text.strip
      if Ticket.code?(stripped)
        result = Result.new([Ticket.includes(:order).find_by_code(stripped)])
        [result] if result
      elsif Order.page_code?(stripped)
        result = Result.new(Ticket.get_page(stripped))
        [result] if result
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
