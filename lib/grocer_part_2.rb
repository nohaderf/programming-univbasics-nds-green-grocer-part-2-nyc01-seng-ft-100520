require_relative './part_1_solution.rb'
require 'pry'

# Returns a new Array. 
# Its members will be a mix of the item Hashes and, where applicable, the "ITEM W/COUPON" Hash. 
# REMEMBER: This method **should** update cart

def apply_coupons(cart, coupons)
  counter = 0
  coupons.each do |coupon|
    item_in_cart = find_item_by_name_in_collection(coupon[:item], cart) 
    cart_item_w_coupon = find_item_by_name_in_collection(coupon[:item] + " W/COUPON", cart)
    if cart_item_w_coupon && item_in_cart[:count] >= coupon[:num] 
        cart_item_w_coupon[:count] += coupon[:num] 
        item_in_cart[:count] -= coupon[:num] 
       elsif item_in_cart && item_in_cart[:count] >= coupon[:num]
        cart << {
          :item => coupon[:item] + " W/COUPON",
          :price => coupon[:cost] / coupon[:num],
          :count => coupon[:num],
          :clearance => item_in_cart[:clearance]
        }
        item_in_cart[:count] -= coupon[:num]
    end 
  end
  counter += 1
end
  cart
end


# Returns a new Array where every unique item in the original is present but with its price reduced by 20% if its :clearance value is true

def apply_clearance(cart)
  new_price_array = []
  cart.each do |item_info|
    if item_info[:clearance] == true
      new_price= item_info[:price] - (item_info[:price] * 0.2)
      new_price_array << {
        :item => item_info[:item],
        :price => new_price,
        :clearance => item_info[:clearance],
        :count => item_info[:count]
      }
    end
  end
  new_price_array
end


 # first create a new consolidated cart using the consolidate_cart method.
 # We should pass the newly consolidated cart to apply_coupons and then send it to apply_clearance.
 # With all the discounts applied, we should loop through the "consolidated and discounts-applied" cart and multiply each item Hash's price by its count and accumulate that to a grand total.
# As one last wrinkle, our grocery store offers a deal for customers buying lots of items. If, after the coupons and discounts are applied, the cart's total is over $100, the customer gets an additional 10% off. Apply this discount when appropriate.
# Returns a float: a total of the cart
 
  



def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  # binding.pry
  total = 0
  counter = 0
  while counter < final_cart.length
    total += final_cart[counter][:price] * final_cart[counter][:count]
    counter += 1
  end
  if total > 100
    total -= (total * 0.1)
  end
  total
end