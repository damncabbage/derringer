module Search
  class Base

    attr_accessor :adapter

    def initialize(adapter=nil)
      @adapter = adapter || default_adapter
    end

    def search(text)
      adapter.find_by_text(text)
    end

    protected

      def default_adapter
        Adapters::Mysql.new(Order.connection)
      end

  end
end
