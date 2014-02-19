require 'csv'
class UploaderController < ApplicationController
  def index
  end

  def upload
    tabfile = params[:tabfile]

    if tabfile.nil?
      flash[:warning] = 'Must supply input file.'
      redirect_to root_path
      return
    end
    file_path = Rails.root.join('public', 'uploads', tabfile.original_filename)
    Dir.mkdir(UPLOADS_DIR) unless Dir.exists? UPLOADS_DIR
    File.open(file_path, 'wb') do |file|
      file.write(tabfile.read)
    end

    begin
      parsed_result = CSV.readlines(tabfile.tempfile, { :col_sep => "\t" })
      # Can inject DataExtractors here.  Crrently using NonDupDataExtractor
      #n = Normalizer.new(SimpleDataExtractor.new, parsed_result)
      n = Normalizer.new(NonDupDataExtractor.new, parsed_result)
      n.normalize()
      @gross_revenue = Order.gross_revenue
      flash[:success] = 'Gross Revenue: %.2f' % @gross_revenue
    rescue => e
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace)
      flash[:warning] = "Could not process input file: #{tabfile.original_filename}"
    end
    redirect_to root_path
  end
end
