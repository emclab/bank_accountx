require 'spec_helper'

module BankAccountx
  describe Account do
    it "should be OK" do
      i = FactoryGirl.build(:account)
      i.should be_valid
    end
    
    it "should reject nil account_name" do
      i = FactoryGirl.build(:account, :account_name => nil)
      i.should_not be_valid
    end
    
    it "should reject nil account_num" do
      i = FactoryGirl.build(:account, :account_num => nil)
      i.should_not be_valid
    end
    
    it "should reject duplicate account num" do
      i = FactoryGirl.create(:account, :account_num => "accountnum")
      i1 = FactoryGirl.build(:account, :account_num => "AccOunTNum")
      i1.should_not be_valid
    end
  end
end
