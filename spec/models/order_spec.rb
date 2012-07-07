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
end
