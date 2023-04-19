class ReimbursementController < ApplicationController
  include Authenticatable
  def show
    reimbursement = if @current_user.admin
          Reimbursement.joins(:user).select("reimbursements.id as id,
            reimbursements.description as description, 
            reimbursements.amount as amount, 
            reimbursements.status as status, 
            users.name as name")
                    else
                      Reimbursement.joins(:user).select("reimbursements.id as id,
                        reimbursements.description as description, 
                        reimbursements.amount as amount, 
                        reimbursements.status as status, 
                        users.name as name").where(user_id: @current_user.id)
                    end
    render json: reimbursement, status: :ok
  end

  def create
    return unless check_not_admin

    reimbursement = Reimbursement.new(description: params[:description], amount: params[:amount], user_id: @current_user.id)
    if reimbursement.save
      render json: { message: 'Reimbursement successfully created.' }, status: :ok
    else
      render json: { message: 'Error creating reimbursement.' }, status: :unprocessable_entity
    end
  end

  def destroy
    reimbursement = Reimbursement.find(params[:id])
    unless reimbursement.present?
      render json: { message: 'Error deleting reimbursement.' }, status: :unprocessable_entity
    end
    return unless check_admin_or_same_user(reimbursement.user.id)

    reimbursement.delete
    render json: { message: 'Reimbursement deleted successfully.' }, status: :ok
  end

  def update
    reimbursement = Reimbursement.find(params[:id])
    unless reimbursement.present?
      render json: { message: 'Error updating reimbursement.' }, status: :unprocessable_entity
    end
    if check_same_user_no_error(reimbursement.user.id) && reimbursement.status.to_i == 1
      desc = if params[:description].nil?
               reimbursement.description
             else
               params[:description]
             end
      amt = if params[:amount].nil?
              reimbursement.amount
            else
              params[:amount]
            end
      if reimbursement.update(description: desc, amount: amt)
        render json: { message: 'Reimbursement updated successfully.' }, status: :ok
      else
        render json: { message: 'Error updating reimbursement.' }, status: :unprocessable_entity
      end
    elsif @current_user.admin
      if reimbursement.update(status: params[:status])
        render json: { message: 'Reimbursement updated successfully.' }, status: :ok
      else
        render json: { message: 'Error updating reimbursement.' }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Error updating reimbursement.' }, status: :unprocessable_entity
    end
  end

  # def update
  #   if @user
  #     todo_list = TodoList.where(id: @request[:params]['id'], user_id: @user.id).first
  #     if todo_list
  #       todo_list.update(@request[:body])
  #       {status: [204, "No Content"], headers: cors}
  #     else
  #       json status: [404, "Not Found"], body: {message: 'Todo not found'}, headers: cors
  #     end
  #   else
  #     json status: [401, "Unauthorized"], body: {message: 'Invalid token'}, headers: cors
  #   end
  # end
end
