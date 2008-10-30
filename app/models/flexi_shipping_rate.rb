class FlexiShippingRate < ActiveRecord::Base
  belongs_to :shipping_category
  
  belongs_to :zone
  
  validates_presence_of :first_item_price
  validates_presence_of :max_items
  
end
