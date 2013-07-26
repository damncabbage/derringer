require 'spec_helper'

describe "Scan Model" do
  context "Unsaved" do
    it "can be saved and found again" do
      subject = FactoryGirl.create(:scan)
      subject.should be_a(Scan)
      scans = Scan.find_all_by_ticket_code(subject.ticket_code)
      scans.count.should == 1

      # This is terrible.
      JSON.generate(scans.first.attributes).should == JSON.generate(subject.attributes)
    end
  end

  context "Saved" do
    subject { FactoryGirl.create(:scan) }

    it "can be found by ticket code (eg. S-F00BAR-0012)" do
      scans = Scan.find_all_by_ticket_code(subject[:ticket_code])
      scans.count.should == 1
      scans.first[:ticket_code].should == subject[:ticket_code]
    end
  end

  context "Multiple Saved" do
    def example_scan
      FactoryGirl.create(:scan, {
        :order_id => 123, :order_code => order_code,
        :ticket_id => 456, :ticket_code => ticket_code
      })
    end

    let(:order_code)  { "S-123123XV" }
    let(:ticket_code) { "#{order_code}-0001" }
    let!(:subject) { [example_scan, example_scan] }

    it "can find two scans for the same ticket" do
      scans = Scan.find_all_by_ticket_code(ticket_code)
      scans.count.should == 2
      scans.each do |scan|
        scan[:order_code].should == order_code
        scan[:ticket_code].should == ticket_code
      end
    end
  end
end
