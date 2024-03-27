require "test_helper"

class ClinicaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get clinica_index_url
    assert_response :success
  end
end
