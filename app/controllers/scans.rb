Derringer.controllers :scans do

  # TODO: Move to main.rb
  post :create do
    # Expect IDs of tickets
    flash[:scanned] = render_partial :haml, "%p Done! Scanned: #{params[:ticket]}"
    redirect url(:index)
  end

end
