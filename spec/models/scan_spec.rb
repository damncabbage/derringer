require 'spec_helper'

describe "Scan Model" do
  context "Unsaved" do
    it "can be saved and found again" do
      subject = FactoryGirl.build(:scan).save
      subject.should be_a(Scan)
      subject.id.should be_a(String)
      subject.id.length.should_not be_blank

      Scan.get(subject.id).try(:id).should == subject.id
    end
  end

  context "Unsaved" do
    subject { FactoryGirl.create(:scan) }

    it "can be found by ticket code (eg. S-F00BAR-0012)" do
      scans = Scan.by_ticket_code.key(subject[:ticket_code])
      scans.count.should == 1
      scans.first[:ticket_code].should == subject[:ticket_code]
    end

    it "can be found by order code (eg. S-F00BAR)" do
      scans = Scan.by_order_code.key(subject[:order_code])
      scans.count.should == 1
      scans.first[:order_code].should == subject[:order_code]
    end
  end
end
