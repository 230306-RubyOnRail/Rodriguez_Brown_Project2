class UserController < ApplicationController
  include Authenticatable
  def create
    return unless check_admin

    user = User.new(username: params[:username], password: params[:password], admin: params[:admin], name: params[:name])
    if user.save
      render json: { message: 'User created successfully' }, status: :ok
      return
    end
    render json: { message: 'Error creating user' }, status: :unprocessable_entity
  end

  def show
    user = if @current_user.admin
             User.all.select('id, admin, name')
           else
             {id: @current_user.id, admin: @current_user.admin, name: @current_user.name}
           end
    render json: user, status: :ok
  end

  def show_single
    return unless check_admin_or_same_user(:id)

    user = User.find(params[:id])
    render json: user, status: :ok
  end

  def destroy
    return unless check_admin

    user = User.find(params[:id])
    return render json: { message: 'Error deleting user' }, status: :unprocessable_entity unless user.present?

    reimbursement = Reimbursement.all.where(user_id: params[:id])
    reimbursement.each do |reim| 
      reim.delete
    end

    user.delete
    render json: { message: 'User deleted successfully' }, status: :ok
  end
end
