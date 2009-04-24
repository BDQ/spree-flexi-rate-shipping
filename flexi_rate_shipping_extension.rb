# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class FlexiRateShippingExtension < Spree::Extension
  version "0.7.1"
  description "Calculates shipping using predefined rates."
  url "http://github.com/BDQ/spree-flexi-rate-shipping/tree/master"
 
  define_routes do |map|
    map.namespace :admin do |admin|
      admin.resources :flexi_shipping_rates
    end  
  end
 
 
  def activate
    ShippingCategory.class_eval do
      has_many :flexi_shipping_rates
    end
    
    Product.class_eval do
      belongs_to :shipping_category
    end
    
    Zone.class_eval do
      has_many :flexi_shipping_rates
    end
    
    Admin::ConfigurationsController.class_eval do
      before_filter :add_flexi_rate_links, :only => :index
      def add_flexi_rate_links
        @extension_links << {:link => admin_flexi_shipping_rates_path, :link_text => FlexiShippingRate.human_name(:count => 2), :description => t('flexi_shipping_rates_description')}
      end
    end
  end
  
  def deactivate
 
  end
end