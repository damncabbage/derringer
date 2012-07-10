Derringer.controller :tickets do

  get :show, :map => '/tickets/:id' do
    @ticket = Ticket.includes(:order).find(params[:id])
    @order = @ticket.order
    render 'tickets/show'
  end

  post :scan, :map => '/orders/:id/scan' do
    @ticket = Ticket.find(params[:id])
    @ticket.scan!
    flash[:scanned] = [@ticket.full_name]
    redirect url(:index)
  end

end
