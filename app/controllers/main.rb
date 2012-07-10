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

end
