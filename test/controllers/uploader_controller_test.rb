require 'test_helper'
require 'fileutils'

class UploaderControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
  test "simple index layout" do
    get :index
    assert_response :success
    assert_select 'h1', 'Uploader'
    assert_select 'hr', 1
    assert_select 'form'
    assert_select 'form input', 3
  end
  test "upload creates UPLOADS_DIR if doesn't exist" do
    FileUtils.rm_rf([UPLOADS_DIR])
    tabfile = my_file_upload('example_input.tab')
    post :upload, tabfile: tabfile
    assert(Dir.exists? UPLOADS_DIR)
  end

  test "upload writes UPLOADS_DIR/tabfile" do
    tabfile = my_file_upload('example_input.tab')
    post :upload, tabfile: tabfile
    file_path = "#{UPLOADS_DIR}/#{tabfile.original_filename}"
    assert(File.exists? file_path)
  end

  test "upload parses file correctly" do
    tabfile = my_file_upload('example_input.tab')
    post :upload, tabfile: tabfile
    assert_response :redirect
    assert_not_nil assigns(:gross_revenue)
    assert_redirected_to root_path
    assert_equal 'Gross Revenue: 114.98', flash[:success]
  end

  test "uploader handles nil correctly" do
    post :upload, tabfile: nil
    assert_response :redirect
    assert_nil assigns(:gross_revenue)
    assert_redirected_to root_path
    assert_equal 'Must supply input file.', flash[:warning]
  end

  test "uploader handles invalid correctly" do
    tabfile = my_file_upload('merchants.yml')
    post :upload, tabfile: tabfile
    assert_response :redirect
    assert_redirected_to root_path
    assert_equal "Could not process input file: #{tabfile.original_filename}", flash[:warning]
  end

  # Because Rack::Test::HtmlUpload and ActionDispatch::Http::UploadedFile work differently
  # I want to be sure I test the exact same thing that the browser is doing
  def my_file_upload(filename)
    ActionDispatch::Http::UploadedFile.new({
                                             filename: filename,
                                             content_type: 'application/octet-stream',
                                             tempfile: File.new("#{Rails.root}/test/fixtures/#{filename}")
                                           })
  end

end
