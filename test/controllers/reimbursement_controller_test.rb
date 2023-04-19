require "test_helper"

class ReimbursementControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = users(:employee)
    @employeetoken = JsonWebToken.encode({user_id: @employee.id})

    @manager = users(:manager)
    @managertoken = JsonWebToken.encode({user_id: @manager.id})

    @employeeReimbursement = reimbursements(:employeeReimbursement)

  end

  test "the truth" do
    assert true
  end

  test "Test for show reimbursements" do
    get '/reimbursements', headers:{'Authorization': @employeetoken }
    assert_response :ok
    assert response.parsed_body.length > 0
  end
  


  
end
