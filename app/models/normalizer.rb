# Takes in a DataExtractor which is basically a config of how to
# extract data from the TSV and create tables
# The DataExtractor is responsible for returning back populated ActiveRecords
# Can extend this to ensure we don't dupe certain fields like:
# - User
# - Merchant
# - Product
# We will still add the new order since the same user can buy the same things from the same merchant
# Perhaps that logic can be in the data extractor?
#
class Normalizer
  def initialize(data_extractor, tsv)
    @data = tsv
    @data_extractor = data_extractor
  end
  def normalize
    @data[1..-1].each do |row|
      o = @data_extractor.extract row
      o.each {|e| e.save }
    end
  end
end