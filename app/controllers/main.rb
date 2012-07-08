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
  end
 
  # /tickets/:id
  get :tickets, :with => :id, :provides => [:json, :html] do
  end

  # /scans/create
  # TODO: Added :parent => :scan, rename to :create
#  post :scan, :map => '/scans/create' do
#    # Expect IDs of tickets
#    flash[:scanned] = render_partial :haml, "%p Done! Scanned: #{params[:ticket]}"
#    redirect url(:index)
#  end
end
