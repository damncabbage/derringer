class OrdersController < ApplicationController
  respond_to :html

  # /orders/:id
  def show
    @order = Order.includes(:tickets).find(params[:id])
    @some_scanned = !!@order.tickets.detect { |t| t.scanned? }
    @selected = params[:tickets] || {}
    respond_with(@order)
  end

  # /orders/:id/scan
  def scan
    @order = Order.includes(:tickets).find(params[:id])
    @order.tickets.each do |ticket|
      ticket.scan!
    end
    flash[:scanned] = @order.tickets.map(&:full_name)
    redirect_to root_url
  end

  # /orders/:id/scan_tickets
  def scan_tickets
    # Expect IDs of tickets
    tickets_by_id = {}
    ticket_ids = params[:tickets].try(:keys) || []

    ticket_ids.each do |id|
      tickets_by_id[id] = Ticket.find(id)
      tickets_by_id[id].scan!
    end

    flash[:scanned] = tickets_by_id.values.map(&:full_name)
    redirect_to root_url
  end

end
