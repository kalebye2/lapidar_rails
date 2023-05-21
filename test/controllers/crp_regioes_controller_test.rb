require 'test_helper'

class CrpRegioesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @crp_regiao = crp_regioes(:one)
  end

  test "should get index" do
    get crp_regioes_url
    assert_response :success
  end

  test "should get new" do
    get new_crp_regiao_url
    assert_response :success
  end

  test "should create crp_regiao" do
    assert_difference('CrpRegiao.count') do
      post crp_regioes_url, params: { crp_regiao: { uf_id: @crp_regiao.uf_id } }
    end

    assert_redirected_to crp_regiao_url(CrpRegiao.last)
  end

  test "should show crp_regiao" do
    get crp_regiao_url(@crp_regiao)
    assert_response :success
  end

  test "should get edit" do
    get edit_crp_regiao_url(@crp_regiao)
    assert_response :success
  end

  test "should update crp_regiao" do
    patch crp_regiao_url(@crp_regiao), params: { crp_regiao: { uf_id: @crp_regiao.uf_id } }
    assert_redirected_to crp_regiao_url(@crp_regiao)
  end

  test "should destroy crp_regiao" do
    assert_difference('CrpRegiao.count', -1) do
      delete crp_regiao_url(@crp_regiao)
    end

    assert_redirected_to crp_regioes_url
  end
end
