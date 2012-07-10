Derringer.controllers do
  # /
  get :index do
    render 'main/search'
  end

  # /search?q=foo+bar
  get :search, :provides => [:json, :html] do
    @q = params[:q].try(:strip)
    @results = ::Search::Base.new.search(@q)

    if Ticket.code?(@q)
      # HACK: Should be handled by Search, not the controller.
      redirect url(:tickets, :show, :id => Ticket.find_by_code(@q))
    elsif @results.count == 1
      # One result? Go directly there. Covers lucky searches AND page scans.
      # TODO: Way of communicating pre-selected tickets.
      redirect url(:orders, :show, :id => @results.order.id)
    end

    case content_type
      when :html then render 'main/search'
      when :json then render :json => params
    end
  end

end
