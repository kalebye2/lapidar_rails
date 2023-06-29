require "test_helper"

class InfantojuvenilAnamnesesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get infantojuvenil_anamneses_index_url
    assert_response :success
  end

  test "should get new" do
    get infantojuvenil_anamneses_new_url
    assert_response :success
  end

  test "should get edit" do
    get infantojuvenil_anamneses_edit_url
    assert_response :success
  end
end
