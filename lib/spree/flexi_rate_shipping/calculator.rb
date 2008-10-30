module Spree
  module FlexiRateShipping
    class Calculator
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
  end
end