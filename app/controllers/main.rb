Derringer.controllers do
  # /
  get :index do
    render 'main/search'
  end

  # /search?q=foo+bar
  get :search do
    @q = params[:q].try(:strip)
    redirect url(:index) if @q.blank?

    @results = []

    if Ticket.code?(@q)
      # Direct ticket lookup
      redirect url(:tickets, :show, :id => Ticket.find_by_code(@q))

    elsif Order.page_code?(@q)
      # Scanning a shortcut-code to pre-select a page full of tickets
      order = Order.order_from_page_code(@q)
      if order
        # HACK: Nasty way of pre-selecting a group of individual tickets belonging to an order.
        tickets = order.page(Order.page_number_for_code(@q))
        selected_ticket_ids = if tickets
                                tickets.inject({}) do |hash,ticket|
                                  hash["tickets[#{ticket.id}]"] = 1
                                  hash
                                end
                              else
                                {}
                              end
        redirect url(:orders, :show, {:id => order.id}.merge(selected_ticket_ids))
      end

    else
      @results = ::Search::Base.new.search(@q)
      # One result? Go directly there. Covers lucky searches AND page scans.
      if @results.count == 1
        redirect url(:orders, :show, :id => @results.first.order.id)
      end
    end

    render 'main/search'
  end

  protected

    def selected_ticket_ids(tickets)
    end

end
