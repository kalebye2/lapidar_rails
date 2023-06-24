require "test_helper"

class InstrumentosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get instrumentos_index_url
    assert_response :success
  end

  test "should get new" do
    get instrumentos_new_url
    assert_response :success
  end

  test "should get edit" do
    get instrumentos_edit_url
    assert_response :success
  end
end
