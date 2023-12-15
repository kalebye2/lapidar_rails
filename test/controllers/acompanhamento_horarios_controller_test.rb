require "test_helper"

class AcompanhamentoHorariosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get acompanhamento_horarios_index_url
    assert_response :success
  end

  test "should get show" do
    get acompanhamento_horarios_show_url
    assert_response :success
  end

  test "should get new" do
    get acompanhamento_horarios_new_url
    assert_response :success
  end

  test "should get create" do
    get acompanhamento_horarios_create_url
    assert_response :success
  end

  test "should get edit" do
    get acompanhamento_horarios_edit_url
    assert_response :success
  end

  test "should get update" do
    get acompanhamento_horarios_update_url
    assert_response :success
  end

  test "should get destroy" do
    get acompanhamento_horarios_destroy_url
    assert_response :success
  end
end
