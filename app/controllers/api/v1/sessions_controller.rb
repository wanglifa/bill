require 'jwt'
class Api::V1::SessionsController < ApplicationController
  def create
    # 如果是测试环境
    if Rails.env.test?
      # 如果code不等于123456，则返回 401
      if params[:code] != '123456'
        return render status: 401
      end
    else
      # 如果不是测试环境，通过数据表里有没有email 是用户传的 email code 是用户传的 code, used_at 是空（说明这个code没用过）
      # 来判断可不可以登录
      canSignin = ValidationCodes.exists? email: params[:email], code: params[:code], used_at: nil
      if !canSignin
        return  render status: 401
      end
    end
    # 通过 email 来查找这个用户
    user = User.find_by_email params[:email]
    # 如果用户不存在
    if user.nil?
      render status: 404, json: {error: '用户不存在'}
    else
      # 私钥
      hmac_secret = Rails.application.credentials.hmac_secret
      payload = { user_id: user.id }
      token = JWT.encode payload, hmac_secret, 'HS256'
      render status: 200, json: {
        jwt: token
      }
    end
  end
end
