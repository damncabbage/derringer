Derringer.controllers do
  # /
  get :index do
    render 'main/search'
  end

  # /search?q=foo+bar
  get :search, :provides => [:json, :html] do
    @q = params[:q]
    @results = ::Search::Base.new.search(@q)
    case content_type
      when :html then render 'main/search'
      when :json then render :json => params
    end
  end

  # /orders/:id
  get :orders, :with => :id, :provides => [:json, :html] do
    @order = Order.includes(:tickets).find(params[:id])
    @all_scanned = @order.tickets.inject(false) do |b,t|
      b = true if t.scanned?; b
    end
    render 'main/orders'
  end

  # /tickets/:id
  get :tickets, :with => :id, :provides => [:json, :html] do
    @ticket = Ticket.includes(:order).find(params[:id])
    @order = @ticket.includes(:tickets).order
    render 'main/tickets'
  end

  # /scans/create
  # TODO: Added :parent => :scan, rename to :create
#  post :scan, :map => '/scans/create' do
#    # Expect IDs of tickets
#    flash[:scanned] = render_partial :haml, "%p Done! Scanned: #{params[:ticket]}"
#    redirect url(:index)
#  end
end
