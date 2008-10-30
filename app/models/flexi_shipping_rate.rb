class FlexiShippingRate < ActiveRecord::Base
  belongs_to :shipping_category
  
  belongs_to :zone
  
  validates_presence_of :first_item_price, :max_items, :shipping_category, :zone
  validates_uniqueness_of :shipping_category_id, :scope => :zone_id, :message => " already exists for the specified Zone."
  
end
