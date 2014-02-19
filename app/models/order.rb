class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :merchant
  belongs_to :product
  def self.gross_revenue
    revenue = 0
    orders = Order.all
    orders.each do |order|
      revenue += order.product.price * order.purchase_count
    end
    revenue
  end
end
