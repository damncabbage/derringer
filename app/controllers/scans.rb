Derringer.controllers :scans do

  # TODO: Move to main.rb
  post :create do
    # Expect IDs of tickets
    tickets_by_id = {}
    ticket_ids = params[:tickets].try(:keys) || []

    ticket_ids.each do |id|
      tickets_by_id[id] = Ticket.find(id)
      tickets_by_id[id].scan!
    end

    flash[:scanned] = render_partial :haml, "%p Done! Scanned: #{tickets_by_id.values.map(&:full_name).join(", ")}"

    redirect url(:index)
  end

end
