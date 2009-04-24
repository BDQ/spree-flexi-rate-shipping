class FlexiShippingRate < ActiveRecord::Base
  belongs_to :shipping_category
  
  belongs_to :zone
  
  validates_presence_of :first_item_price, :max_items, :shipping_category, :zone
  validates_uniqueness_of :shipping_category_id, :scope => :zone_id 

  named_scope :order_by_zone_and_category, :order => "zone_id, shipping_category_id"
  
end
