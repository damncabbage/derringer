module SearchHelpers

  def search_for(text)
    # Relies on the user already being on the index or the search
    # results page.
    fill_in 'terms', :with => text
    click_button 'Go'
  end

end

RSpec.configure do |c|
    c.include SearchHelpers, :type => :request
end
