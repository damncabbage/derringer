require 'spec_helper'

describe "Ticket and Order Search" do

  let(:agent) { Search::Base.new }

  before do
    # To be found
    order = FactoryGirl.create(:order, {
      :full_name => "Order Find My Name",
      :email => "find@my.name"
    })
    order.tickets << FactoryGirl.build(:ticket, :full_name => "Ticket Find My Name", :order => order)

    # To be ignored
    FactoryGirl.create(:order_with_ticket)
    FactoryGirl.create(:order_with_tickets)
  end

  shared_examples_for "a search agent finding Find My Name order" do
    it { should have(1).items }
    it { subject.first.should have(1).tickets }
    it { subject.first.tickets.first.full_name.should eql 'Ticket Find My Name' }
    it { subject.first.order.full_name.should eql 'Order Find My Name' }
  end

  context "when searching for an order" do
    subject { agent.search("Order Find") }
    it_should_behave_like "a search agent finding Find My Name order"
  end

  context "when searching for a ticket" do
    subject { agent.search("Ticket Find") }
    it_should_behave_like "a search agent finding Find My Name order"
  end
end
