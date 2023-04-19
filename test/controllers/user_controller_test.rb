require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = users(:employee)
    @employeetoken = JsonWebToken.encode({user_id: @employee.id})

    @manager = users(:manager)
    @managertoken = JsonWebToken.encode({user_id: @manager.id})
  end

  test "the truth" do
    assert true
  end

  test "user show returns json" do
    get '/users' , headers: {'Authorization': @managertoken } 
    assert_response :ok
    assert response.parsed_body.length > 0
  end

  test "user post returns ok" do
    post '/users' ,  headers: {'Authorization': @managertoken }, params: {username: 'Spiderman', password: 'Password321', admin: true, name: 'Tobby'}, as: :json
    assert_response :ok
  end

  test "user post for employee" do
    post '/users' ,  headers: {'Authorization': @employeetoken }, params: {username: 'Spiderman2', password: '2Password321', admin: true, name: 'NotTobby'}, as: :json
    assert_response :forbidden
  end

  test "user deletes" do
    delete "/users/" + @employee.id.to_s, headers: {'Authorization': @managertoken }
    assert_response :ok
  end

end
