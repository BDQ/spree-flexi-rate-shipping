require File.dirname(__FILE__) + '/../spec_helper'
 

describe Spree::FlexiRateShipping::Calculator do
  before(:each) do
		@zone = mock_model(Zone, :name => "North America", :include? => true)
		
    @flexi_shipping_rate1 = mock_model(FlexiShippingRate, :first_item_price => 10.0, :additional_item_price => 2.0, :max_items => 6, :zone => @zone)

    @shipping_category1 = mock_model(ShippingCategory, :flexi_shipping_rates => [@flexi_shipping_rate1])
    @product1 = mock_model(Product, :shipping_category => @shipping_category1)
    @variant1 = mock_model(Variant, :product => @product1)

		@address = mock_model(Address, :zone => @zone)
  end

  it "should calculate shipping with no flexi shipping rate" do
    @shipping_category1 = mock_model(ShippingCategory, :flexi_shipping_rates => [])
    @product1 = mock_model(Product, :shipping_category => @shipping_category1)
    @variant1 = mock_model(Variant, :product => @product1)
    
    @line_item1 = mock_model(LineItem, :variant => @variant1, :quantity => 1)
    @line_items = [@line_item1]
    @order = mock_model(Order, :line_items => @line_items)
		@shipment = mock_model(Shipment, :order => @order, :address => @address)
    
    Spree::FlexiRateShipping::Calculator.new().calculate_shipping(@shipment).should == 0.0
  end
  
  it "should calculate shipping with one product with no flexi shipping rate" do
    @no_rate_shipping_category = mock_model(ShippingCategory, :flexi_shipping_rates => [])
    @product1 = mock_model(Product, :shipping_category => @no_rate_shipping_category)
    @variant1 = mock_model(Variant, :product => @product1)
    
    @line_item1 = mock_model(LineItem, :variant => @variant1, :quantity => 1)
        
    @product2 = mock_model(Product, :shipping_category => @shipping_category1)
    @variant2 = mock_model(Variant, :product => @product2)
    @line_item2 = mock_model(LineItem, :variant => @variant2, :quantity => 2)
    
    @line_items = [@line_item1, @line_item2]
    @order = mock_model(Order, :line_items => @line_items)
		@shipment = mock_model(Shipment, :order => @order, :address => @address)
    
    Spree::FlexiRateShipping::Calculator.new().calculate_shipping(@shipment).should == 12.0
  end

  
  it "should calculate shipping with one product with no shipping category" do
    @product1 = mock_model(Product, :shipping_category => nil)
    @variant1 = mock_model(Variant, :product => @product1)
    
    @line_item1 = mock_model(LineItem, :variant => @variant1, :quantity => 7)

    @product2 = mock_model(Product, :shipping_category => @shipping_category1)
    @variant2 = mock_model(Variant, :product => @product2)
    @line_item2 = mock_model(LineItem, :variant => @variant2, :quantity => 2)
    
    @line_items = [@line_item1, @line_item2]
    @order = mock_model(Order, :line_items => @line_items)
		@shipment = mock_model(Shipment, :order => @order, :address => @address)
    
    Spree::FlexiRateShipping::Calculator.new().calculate_shipping(@shipment).should == 12.0
  end
  
  it "should calculate shipping with no shipping category" do
    @product1 = mock_model(Product, :shipping_category => nil)
    @variant1 = mock_model(Variant, :product => @product1)
    
    @line_item1 = mock_model(LineItem, :variant => @variant1, :quantity => 7)
    @line_items = [@line_item1]
    @order = mock_model(Order, :line_items => @line_items)
		@shipment = mock_model(Shipment, :order => @order, :address => @address)
    
    Spree::FlexiRateShipping::Calculator.new().calculate_shipping(@shipment).should == 0.0
  end

  it "should calculate shipping correctly using one flexi shipping rate and one product" do
    @line_item1 = mock_model(LineItem, :variant => @variant1, :quantity => 7)
    @line_items = [@line_item1]
    @order = mock_model(Order, :line_items => @line_items)
		@shipment = mock_model(Shipment, :order => @order, :address => @address)
    
    Spree::FlexiRateShipping::Calculator.new().calculate_shipping(@shipment).should == 30.0
  end
  
  it "should calculate shipping correctly using one flexi shipping rate and multiple products" do
    @line_item1 = mock_model(LineItem, :variant => @variant1, :quantity => 3)
    
    @product2 = mock_model(Product, :shipping_category => @shipping_category1)
    @variant2 = mock_model(Variant, :product => @product2)
    @line_item2 = mock_model(LineItem, :variant => @variant2, :quantity => 2)
    
    @product3 = mock_model(Product, :shipping_category => @shipping_category1)
    @variant3 = mock_model(Variant, :product => @product3)
    @line_item3 = mock_model(LineItem, :variant => @variant3, :quantity => 4)
    
    @line_items = [@line_item1, @line_item2, @line_item3]
    @order = mock_model(Order, :line_items => @line_items)
		@shipment = mock_model(Shipment, :order => @order, :address => @address)
    
    Spree::FlexiRateShipping::Calculator.new().calculate_shipping(@shipment).should == 34.0
  end
  
  it "should calculate shipping correctly using two different flexi shipping rates" do
   
    @flexi_shipping_rate2 = mock_model(FlexiShippingRate, :first_item_price => 50, :additional_item_price => 10, :max_items => 10, :zone => @zone)
    @shipping_category2 = mock_model(ShippingCategory, :flexi_shipping_rates => [@flexi_shipping_rate2])
    @product2 = mock_model(Product, :shipping_category => @shipping_category2)
    @variant2 = mock_model(Variant, :product => @product2)
    
    @line_item1 = mock_model(LineItem, :variant => @variant1, :quantity => 6)
    @line_item2 = mock_model(LineItem, :variant => @variant2, :quantity => 3)
    @line_items = [@line_item1, @line_item2]
    @order = mock_model(Order, :line_items => @line_items)
		@shipment = mock_model(Shipment, :order => @order, :address => @address)
    
    Spree::FlexiRateShipping::Calculator.new().calculate_shipping(@shipment).should == 90.0
  end
  
  
  it "should calculate shipping correctly using two different flexi shipping rates, one with no addition_item_price" do
   
    @flexi_shipping_rate2 = mock_model(FlexiShippingRate, :first_item_price => 50, :additional_item_price => nil, :max_items => 1, :zone => @zone)
    @shipping_category2 = mock_model(ShippingCategory, :flexi_shipping_rates => [@flexi_shipping_rate2])
    @product2 = mock_model(Product, :shipping_category => @shipping_category2)
    @variant2 = mock_model(Variant, :product => @product2)
    
    @line_item1 = mock_model(LineItem, :variant => @variant1, :quantity => 6)
    @line_item2 = mock_model(LineItem, :variant => @variant2, :quantity => 1)
    @line_items = [@line_item1, @line_item2]
    @order = mock_model(Order, :line_items => @line_items)
		@shipment = mock_model(Shipment, :order => @order, :address => @address)
    
    Spree::FlexiRateShipping::Calculator.new().calculate_shipping(@shipment).should == 70.0
  end


end
