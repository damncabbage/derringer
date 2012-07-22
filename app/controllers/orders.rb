Derringer.controller :orders do

  get :show, :map => '/orders/:id' do
    @order = Order.includes(:tickets).find(params[:id])
    @some_scanned = !!@order.tickets.detect { |t| t.scanned? }
    @selected = params[:tickets] || {}
    render 'orders/show'
  end

  post :scan, :map => '/orders/:id/scan' do
    @order = Order.includes(:tickets).find(params[:id])
    @order.tickets.each do |ticket|
      ticket.scan!
    end
    flash[:scanned] = @order.tickets.map(&:full_name)
    redirect url(:index)
  end

  post :scan_tickets, :map => '/orders/:id/scan_tickets' do
    # Expect IDs of tickets
    tickets_by_id = {}
    ticket_ids = params[:tickets].try(:keys) || []

    ticket_ids.each do |id|
      tickets_by_id[id] = Ticket.find(id)
      tickets_by_id[id].scan!
    end

    flash[:scanned] = tickets_by_id.values.map(&:full_name)
    redirect url(:index)
  end

end
