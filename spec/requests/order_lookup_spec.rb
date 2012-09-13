require 'spec_helper'

describe 'Order Lookup', :type => :request do
  before do
    # Order to be ignored by lookup.
    FactoryGirl.create(:order_with_tickets)
  end

  before do
    visit '/'
    search_for order.code
  end

  context "when typing or scanning an order code" do
    let(:order) { FactoryGirl.create(:order_with_tickets) }

    it "should jump directly to the order confirmation page" do
      current_path.should == "/orders/#{order.id}"
      page.should have_content order.full_name
      page.should have_content order.code
    end

    it "should list all tickets for this order" do
      page.should have_css('ul.orders li', :count => 3)
      within('ul.orders') do
        page.should have_content(order.tickets[0].full_name)
        page.should have_content(order.tickets[1].full_name)
        page.should have_content(order.tickets[2].full_name)
      end
    end

    it "should let the user choose all tickets to scan by clicking Everybody" do
      click_button 'Everybody'
      page.should have_content 'Success! Scanned:'
      scans = Scan.find_all_by_order_code(order.code)
      scans.count.should == 3

      # Make sure the ticket is scanned and printed on the page.
      order.tickets.each_with_index do |ticket, idx|
        page.should have_content ticket.full_name
        scans.detect do |scan|
          scan[:ticket_code] == ticket.code
        end.should_not be_nil
      end
    end

    pending "should let the user choose all tickets to scan by clicking 'This one' next to each"
    pending "should let the user choose one ticket to scan by clicking 'This one' next to it"
    pending "should let the user choose two tickets to scan by clicking 'This one' next to each"

  end
end
