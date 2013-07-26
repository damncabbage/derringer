require 'spec_helper'

describe "Order Model" do
  let(:order) { Order.new }
  it 'can be created' do
    order.should_not be_nil
  end

  context "when identifying barcodes" do
    it "should recognise valid order barcodes" do
      Order.code?('S-5HKH4MR').should_not be_nil 
      Order.code?('S-5HKH4MRR').should be_nil # Too long
      Order.code?('S-5HKH4MZ').should be_nil # Invalid character
      Order.code?('S1-5HKH4MR').should be_nil # 2011 barcode
      Order.code?('S1-5HKH4M').should be_nil # 2011 barcode
    end

    it "should recognise valid page barcodes" do
      Order.page_code?('S-5HKH4MR-%M01').should_not be_nil 
      Order.page_number_for_code('S-5HKH4MR-%M01').should == 1
      Order.page_number_for_code('S-5HKH4MR-%M18').should == 18

      Order.page_code?('S-5HKH4MRR-%M01').should be_nil # Invalid order code
      Order.page_code?('S-5HKH4MR-%N01').should be_nil # Invalid character
      Order.page_code?('S-5HKH4MR-%M001').should be_nil # Too long
    end
  end

  context "when searching by paid / unpaid status" do
    let!(:paid)   { FactoryGirl.create(:order_with_ticket, :status => Order::RESOLVED) }
    let!(:unpaid) { FactoryGirl.create(:order_with_ticket, :status => Order::PAYMENT_PENDING) }

    it "should find all with no scope" do
      Order.unscoped.count.should == 2
    end

    it "should find resolved orders with the paid scope" do
      Order.paid.count.should == 1
      Order.paid.first.should be_paid
      Order.paid.first.status.should == 'resolved'
      Ticket.paid.find_by_order_id(paid.id).should == paid.tickets.first
    end

    it "should find unresolved orders with the unpaid scope" do
      Order.unpaid.count.should == 1
      Order.unpaid.first.should be_unpaid
      Order.unpaid.first.status.should == 'payment_pending'
      Ticket.unpaid.find_by_order_id(unpaid.id).should == unpaid.tickets.first
    end
  end
end
