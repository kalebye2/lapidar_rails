require "test_helper"

class CivilEstadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @civil_estado = civil_estados(:one)
  end

  test "should get index" do
    get civil_estados_url
    assert_response :success
  end

  test "should get new" do
    get new_civil_estado_url
    assert_response :success
  end

  test "should create civil_estado" do
    assert_difference("CivilEstado.count") do
      post civil_estados_url, params: { civil_estado: { estado: @civil_estado.estado } }
    end

    assert_redirected_to civil_estado_url(CivilEstado.last)
  end

  test "should show civil_estado" do
    get civil_estado_url(@civil_estado)
    assert_response :success
  end

  test "should get edit" do
    get edit_civil_estado_url(@civil_estado)
    assert_response :success
  end

  test "should update civil_estado" do
    patch civil_estado_url(@civil_estado), params: { civil_estado: { estado: @civil_estado.estado } }
    assert_redirected_to civil_estado_url(@civil_estado)
  end

  test "should destroy civil_estado" do
    assert_difference("CivilEstado.count", -1) do
      delete civil_estado_url(@civil_estado)
    end

    assert_redirected_to civil_estados_url
  end
end
