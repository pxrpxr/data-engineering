require 'test_helper'
class NormalizerTest < ActionView::TestCase
  test 'test we can normalize example input using simple extractor' do
    s = SimpleDataExtractor.new
    tabfile       = fixture_file_upload('example_input.tab', 'text/plain')
    parsed_result = CSV.readlines(tabfile, { :col_sep => "\t" })
    n = Normalizer.new(SimpleDataExtractor.new, parsed_result[0..1])

    assert_difference(%w(User.count Product.count Merchant.count)) do
      n.normalize()
    end
  end
  test 'ensure we have the correct values loaded in the database from example input' do
    s = SimpleDataExtractor.new
    tabfile       = fixture_file_upload('example_input.tab', 'text/plain')
    parsed_result = CSV.readlines(tabfile, { :col_sep => "\t" })
    n = Normalizer.new(SimpleDataExtractor.new, parsed_result)
    n.normalize()
    assert_nil User.find_by_name('purchaser name')
    assert_not_nil User.find_by_name('Snake Plissken')
    assert_not_nil User.find_by_name('Amy Pond')
    assert_equal(2, User.where(name: 'Snake Plissken').size)
    assert_equal(4+2, Order.all().size) # fixtures insert data
  end
  test "only one makes in to the database" do
    s = NonDupDataExtractor.new
    rows = []
    data = []
    data << 'Snake Plissken'
    data << '$10 off $20 of food'
    data << '10.0'
    data << '2'
    data << '987 Fake St'
    data << 'Bob\'s Pizza'

    rows << %w(one two three four five)
    rows << data

    n = Normalizer.new(NonDupDataExtractor.new, rows)
    assert_difference(%w(User.count Product.count Merchant.count)) do
      n.normalize()
    end

    assert_nil User.find_by_name('purchaser name')
    assert_equal(1+2, Order.all().size) # fixtures insert data

    u_res = User.where(name: 'Snake Plissken')
    p_res = Product.where(description: '$10 off $20 of food')
    m_res = Merchant.where(name: 'Bob\'s Pizza')

    assert(u_res.length == 1)
    assert(p_res.length == 1)
    assert(m_res.length == 1)

    assert(Order.where(user: u_res.first).length == 1)

    assert_no_difference(%w(User.count Product.count Merchant.count)) do
      n.normalize()
    end
    assert(Order.where(user: u_res.first).length == 2)
  end
end
