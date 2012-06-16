require 'spec_helper'

describe "Ticket Model" do
  let(:ticket) { Ticket.new }
  it 'can be created' do
    ticket.should_not be_nil
  end
end
