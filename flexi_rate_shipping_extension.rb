# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class FlexiRateShippingExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/flexi_rate_shipping"
 
  define_routes do |map|
    map.namespace :admin do |admin|
      admin.resources :flexi_shipping_rates
    end  
  end
 
 
  def activate
    ShippingCategory.class_eval do
      has_one :flexi_shipping_rate
    end
    
    Product.class_eval do
      belongs_to :shipping_category
    end
    
    Admin::ConfigurationsController.class_eval do
      before_filter :add_flexi_rate_links, :only => :index
      def add_flexi_rate_links
        @extension_links << {:link => admin_flexi_shipping_rates_path, :link_text => Globalite.localize(:ext_flexi_shipping_rates), :description => Globalite.localize(:ext_flexi_shipping_rates_description)}
      end
    end
  end
  
  def deactivate
 
  end

  def calculate_shipping(order)
    rates = {}
    rate_count = {}
    order.line_items.each do |li|
      
      li.quantity.times do 
        sc = li.variant.product.shipping_category
        sc ||= ShippingCategory.new()
        fsr = sc.flexi_shipping_rate
        fsr ||= FlexiShippingRate.new(:id => 'default', :first_item_price => 0, :max_items => 1)
        rate_count.has_key?(fsr.id) ? rate_count[fsr.id] += 1 : rate_count[fsr.id] = 1
        
        rates[fsr.id] = 0 unless rates.has_key? fsr.id
        
        if rates[fsr.id] == 0
          #first time to add a product from this flexi-rate
          rates[fsr.id] +=  fsr.first_item_price
        else
          #additional time to add a product from this flexi-rate
          
          if rate_count[fsr.id] % fsr.max_items == 1
            rates[fsr.id] += fsr.first_item_price
          else
            rates[fsr.id] += fsr.additional_item_price
          end

        end
      end
      
    end

    return rates.values.inject(0){|sum, c| sum + c}
  end
end