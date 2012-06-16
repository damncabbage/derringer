require 'spec_helper'

describe "Order Model" do
  let(:order) { Order.new }
  it 'can be created' do
    order.should_not be_nil
  end
end
