require "test_helper"

class ProfissionalFolgasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profissional_folga = profissional_folgas(:one)
  end

  test "should get index" do
    get profissional_folgas_url
    assert_response :success
  end

  test "should get new" do
    get new_profissional_folga_url
    assert_response :success
  end

  test "should create profissional_folga" do
    assert_difference("ProfissionalFolga.count") do
      post profissional_folgas_url, params: { profissional_folga: {  } }
    end

    assert_redirected_to profissional_folga_url(ProfissionalFolga.last)
  end

  test "should show profissional_folga" do
    get profissional_folga_url(@profissional_folga)
    assert_response :success
  end

  test "should get edit" do
    get edit_profissional_folga_url(@profissional_folga)
    assert_response :success
  end

  test "should update profissional_folga" do
    patch profissional_folga_url(@profissional_folga), params: { profissional_folga: {  } }
    assert_redirected_to profissional_folga_url(@profissional_folga)
  end

  test "should destroy profissional_folga" do
    assert_difference("ProfissionalFolga.count", -1) do
      delete profissional_folga_url(@profissional_folga)
    end

    assert_redirected_to profissional_folgas_url
  end
end
