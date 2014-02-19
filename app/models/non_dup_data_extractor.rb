class NonDupDataExtractor
  def extract(data)
    # Return back ActiveRecord objects.
    # Normalizer will iterate through the list and call save.

    name           = data[0] # User
    description    = data[1] # Product
    price          = data[2] # Product
    purchase_count = data[3] # Order
    address        = data[4] # Merchant
    m_name         = data[5] # Merchant

    u = User.where(name: name)
    if(u.empty?)
      u = User.new
      u.name = name
    else
      u = u.first
    end

    p = Product.where(description: description)
    if(p.empty?)
      p = Product.new
      p.description = description
      p.price = price
    else
      p = p.first
    end

    m = Merchant.where(name: m_name)
    if(m.empty?)
      m = Merchant.new
      m.name = m_name
      m.address = address
    else
      m = m.first
    end

    o = Order.new
    o.user     = u
    o.product  = p
    o.merchant = m
    o.purchase_count = purchase_count
    [u,p,m,o]
  end
end