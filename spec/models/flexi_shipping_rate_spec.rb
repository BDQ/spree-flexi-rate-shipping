require File.dirname(__FILE__) + '/../spec_helper'

describe FlexiShippingRate do
  before(:each) do
    @flexi_shipping_rate = FlexiShippingRate.new
  end

  ['first item price', 'max. number of items'].each do |field|
    it "should require #{field}" do
      @flexi_shipping_rate.max_items = nil
      @flexi_shipping_rate.valid?.should be_false
      @flexi_shipping_rate.errors.full_messages.should include("#{field.capitalize} can't be blank")
    end
  end

end
