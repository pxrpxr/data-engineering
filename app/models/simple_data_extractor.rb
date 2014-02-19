# In case the format changes or we want to extract data in a slightly different way.
# We keep the logic of how to extract the stuff out of TSV here.
# Input: TSV Rows
# Ouput:
# purchaser name   |0| User.name
# item description |1| Product.description
# item price       |2| Product.price
# purchase count   |3| |Order.count|
# merchant address |4| Merchant.address
# merchant name    |5| Merchant.name
#
# This should class should return back a list of commands for the Normalizer to execute
# SimpleDataExtractor doesn't concern itself with dupes etc...
# if the same User is present twice then we will insert that user twice.
class SimpleDataExtractor
  def extract(data)
    # Return back ActiveRecord objects.
    # Normalizer will iterate through the list and call save.
    u = User.new
    p = Product.new
    m = Merchant.new
    o = Order.new

    u.name           = data[0]
    p.description    = data[1]
    p.price          = data[2]
    o.purchase_count = data[3]
    m.address        = data[4]
    m.name           = data[5]

    o.user     = u
    o.product  = p
    o.merchant = m
    [u,p,m,o]
  end

end