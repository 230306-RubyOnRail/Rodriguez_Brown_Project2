# frozen_string_literal: true
require_relative '../../../lib/json_web_token'

module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
    attr_reader :current_user
  end

  private

  def authenticate_request
    token_data = JsonWebToken.decode(token)
    @current_user = User.find(JsonWebToken.decode(token)['user_id'])
    render json: { error: 'Not Authorized' }, status: 401 unless current_user
    # render json: { error: 'You are not allowed to perform this action' }, status: 403 unless params[:user_id] && @current_user.id == params[:user_id].to_i
  end

  def token
    request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
  end

  def check_admin_or_same_user(id)
    unless @current_user.id == id || @current_user.admin == true
      render json: { error: 'You are not allowed to perform this action' }, status: 403
      return false
    end
    true
  end

  def check_admin
    unless @current_user.admin == true
      render json: { error: 'You are not allowed to perform this action' }, status: 403
      return false
    end
    true
  end

  def check_not_admin
    unless @current_user.admin == false
      render json: { error: 'You are not allowed to perform this action' }, status: 403
      return false
    end
    true
  end

  def check_same_user(id)
    unless @current_user.id == id
      render json: { error: 'You are not allowed to perform this action' }, status: 403
      return false
    end
    true
  end

  def check_same_user_no_error(id)
    return true if @current_user.id == id

    false
  end
end