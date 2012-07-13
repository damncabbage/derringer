Derringer.controllers :stats do
  # /stats
  get :index do
    @scanned = Ticket.paid.where(:scanned => true).count
    @total   = Ticket.paid.count
    render 'stats/index'
  end
end

