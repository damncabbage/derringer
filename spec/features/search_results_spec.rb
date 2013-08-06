require 'spec_helper'

describe 'Search Result Details' do
  before do
    # Orders to be ignored by search.
    # HACK: MySQL Natural Language search requires that a search
    # result be less than 33% of the total; that means we need 10
    # records to display 3 test results. That unfortunately means
    # some hideously slow specs.
    FactoryGirl.create(:order_with_tickets)
    FactoryGirl.create(:order_with_tickets)
    FactoryGirl.create(:order_with_tickets)
    FactoryGirl.create(:order_with_tickets)
    FactoryGirl.create(:order_with_tickets)
    FactoryGirl.create(:order_with_ticket)
  end

  let!(:order) do
    FactoryGirl.create(:order_with_tickets,
                       :full_name => 'Specialsnowflake Wang')
  end
  let!(:other_order) do
    FactoryGirl.create(:order_with_tickets,
                       :full_name => "Vera Wang")
  end
  let!(:unpaid_order) do
    FactoryGirl.create(:order_with_tickets,
                       :full_name => 'Yi Wang',
                       :status => "payment_pending")
  end

  context "when searching for an order under a common name" do
    # 2012 had 27 tickets with the last name "Wang". Consider this
    # a real-world case. :)
    before do
      visit '/'
      search_for 'Wang'
    end

    it "should only display Wang orders" do
      page.should have_css('ul#search-results li.order', :count => 3)
    end

    it "should display all orders in the search results" do
      [order, other_order, unpaid_order].each do |o|
        # Definitely not bullet-proof.
        page.should have_content o.full_name
        page.should have_content o.code
        o.tickets.each do |t|
          page.should have_content t.full_name
        end
      end
    end

    it "should warn of an unpaid order" do
      page.should have_css("a[href=\"/orders/#{unpaid_order.id}\"] .unpaid", :count => 1)
    end

    it "should take the user to the order when the order is clicked" do
      find("a[href=\"/orders/#{order.id}\"]").click
      current_path.should == "/orders/#{order.id}"
      page.should have_content order.code
      page.should have_content "Ordered by #{order.full_name}"
    end
  end

  context "when searching for an order with a unique name" do
    before do
      visit '/'
      search_for 'Specialsnowflake'
    end
    it "should take the user directly to the order page" do
      current_path.should == "/orders/#{order.id}"
    end
  end

  context "when searching for a nonexistent ticket or order" do
    before do
      visit '/'
      search_for 'This Does Not Exist'
    end
    it "should print a nothing-found message" do
      page.should have_content "Couldn't find anything!"
    end
  end
end
