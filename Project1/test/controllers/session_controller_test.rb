require "test_helper"
require_relative '../../lib/json_web_token'

class SessionControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = users(:employee)
    @employeetoken = JsonWebToken.encode({user_id: @employee.id})

    @manager = users(:manager)
    @managertoken = JsonWebToken.encode({user_id: @manager.id})
  end

  test "the truth" do
    assert true
  end

  test "login works" do
    post "/login", params: {username: @employee.username, password: 'Password2'}, as: :json
    assert_response :created
    assert_equal @employee.id, response.parsed_body['id']
  end

  test"login works with manager" do
    post "/login", params: {username: @manager.username, password: 'Password1'}, as: :json
    assert_response :created
    assert_equal @manager.id, response.parsed_body['id']
  end
  

end
