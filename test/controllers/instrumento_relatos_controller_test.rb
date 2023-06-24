require "test_helper"

class InstrumentoRelatosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get instrumento_relatos_index_url
    assert_response :success
  end

  test "should get new" do
    get instrumento_relatos_new_url
    assert_response :success
  end

  test "should get edit" do
    get instrumento_relatos_edit_url
    assert_response :success
  end
end
