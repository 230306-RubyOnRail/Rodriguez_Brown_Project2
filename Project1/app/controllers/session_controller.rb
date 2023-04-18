# frozen_string_literal: true
require_relative '../../lib/json_web_token'

class SessionController < ApplicationController
  def create
    credentials = JSON.parse(request.body.read)
    user = User.where(username: credentials['username']).first
    return head :unauthorized unless user

    puts user.inspect
    puts credentials['password']
    if user.authenticate(credentials['password'])
      render json: { token: JsonWebToken.encode(user_id: user.id), id: user.id, name: user.name, admin: user.admin}, status: :created
    else
      head :unauthorized
    end
  end
end
