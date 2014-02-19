require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "gross revenue" do
    assert_equal(19.98, Order.gross_revenue)
  end
end
