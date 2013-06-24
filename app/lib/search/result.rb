module Search
  # Represents a single row in a search results list.
  class Result

    attr_reader :order, :tickets

    def initialize(tickets)
      @order = tickets.first.order
      @tickets = tickets
    end

  end
end
