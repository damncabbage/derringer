Derringer.controllers do
  # /
  get :index do
    render 'main/search'
  end

  # /search?q=foo+bar
  get :search, :provides => [:json, :html] do
    @q = params[:q].try(:strip)
    redirect url(:index) if @q.blank?

    @results = []

    if Ticket.code?(@q)
      redirect url(:tickets, :show, :id => Ticket.find_by_code(@q))
    elsif Order.page_code?(@q)
      order = Order.order_from_page_code(@q)
      if order
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
      if @results.count == 1
        # One result? Go directly there. Covers lucky searches AND page scans.
        redirect url(:orders, :show, :id => @results.first.order.id)
      end
    end

    case content_type
      when :html then render 'main/search'
      when :json then render :json => params
    end
  end

  protected

    def selected_ticket_ids(tickets)
    end

end
