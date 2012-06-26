require 'spec_helper'

describe "Ticket and Order Search" do

  let(:searcher) { Search.new(Order.connection) }

  let!(:found) do
    FactoryGirl.create(:order, {
      :full_name => "Find My Name",
      :email => "find@my.name"
    })
  end
  let!(:not_found) do
    [ FactoryGirl.create(:order), FactoryGirl.create(:order) ]
  end

  it "should find an order by its full name or email" do
    results = searcher.find_orders("Find")
    results.count.should == 1
    results.first.full_name.should == 'Find My Name'
  end


end
