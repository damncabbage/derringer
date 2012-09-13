require 'spec_helper'

describe 'Ticket Lookup', :type => :request do
  before do
    # Order to be ignored by lookup.
    FactoryGirl.create(:order_with_tickets)
  end

  before do
    visit '/'
    search_for ticket.code
  end

  context "when typing or scanning a ticket code" do
    let(:order)  { FactoryGirl.create(:order_with_tickets) }
    let(:ticket) { order.tickets.first }

    it "should jump directly to the ticket confirmation page" do
      page.should have_content ticket.full_name
      page.should have_content order.code
      page.should have_content "From an order with #{order.tickets.count} people"
    end

    it "should take the user to the order when the order code is clicked" do
      click_link order.code
      current_path.should == "/orders/#{order.id}"
      page.should have_content order.code
      page.should have_content "Ordered by #{order.full_name}"
    end

    it "should confirm the ticket when the button is pressed" do
      click_button 'Confirm this Ticket'
      page.should have_content 'Success! Scanned:'
      page.should have_content ticket.full_name
      scans = Scan.find_all_by_ticket_code(ticket.code)
      scans.count.should == 1
      scans.first[:ticket_code].should == ticket.code
    end
  end

  context "when typing or scanning a ticket code for an unpaid ticket" do
    let(:order)  { FactoryGirl.create(:order_with_tickets, :status => 'payment_pending') }
    let(:ticket) { order.tickets.first }

    it "should display an Unpaid Ticket warning" do
      page.should have_content 'not been paid for'
    end
  end
end
