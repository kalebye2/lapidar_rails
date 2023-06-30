require "test_helper"

class BibliotecaObrasControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get biblioteca_obras_index_url
    assert_response :success
  end

  test "should get show" do
    get biblioteca_obras_show_url
    assert_response :success
  end

  test "should get new" do
    get biblioteca_obras_new_url
    assert_response :success
  end

  test "should get edit" do
    get biblioteca_obras_edit_url
    assert_response :success
  end
end
