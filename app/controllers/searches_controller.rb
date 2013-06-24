class SearchesController < ApplicationController
  respond_to :html

  # /search?q=foo+bar
  def search
    @q = params[:q].try(:strip)
    return render :search if @q.blank?

    @results = []

    if Ticket.code?(@q)
      # Direct ticket lookup
      # TODO
      redirect_to ticket_url(Ticket.find_by_code(@q))

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
        # TODO: Uh oh.
        #redirect url(:orders, :show, {:id => order.id}.merge(selected_ticket_ids))
        redirect_to order_url(order, selected_ticket_ids)
      else
        render :search
      end

    else
      @results = ::Search::Base.new.search(@q)
      # One result? Go directly there. Covers lucky searches AND page scans.
      if @results.count == 1
        redirect_to order_url(@results.first.order)
      else
        render :search
      end
    end
  end

  protected

    def selected_ticket_ids(tickets)
    end

end
