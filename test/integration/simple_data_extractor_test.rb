require 'test_helper'

class SimpleDataExtractorTest < ActionView::TestCase
  test "extracts correct data" do
    s = SimpleDataExtractor.new
    data = []
    data << 'Snake Plissken'
    data << '$10 off $20 of food'
    data << '10.0'
    data << '2'
    data << '987 Fake St'
    data << 'Bob\'s Pizza'

    result = s.extract data
    assert_not_nil(result)
    assert(result.is_a?(Array), 'Result is an Array')
    assert(result[0].is_a?(User))
    assert(result[1].is_a?(Product))
    assert(result[2].is_a?(Merchant))
    assert(result[3].is_a?(Order))
  end
end
