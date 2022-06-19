class Api::V1::MesController < ApplicationController
  def show
    header = request.headers['Authorization']
    # 如果 header.split(' ')[1] 获取报错就让它等于空字符串，rescue 就相当于 try catch
    jwt = header.split(' ')[1] rescue ''
    payload = JWT.decode jwt, Rails.application.credentials.hmac_secret, true, { algorithm: 'HS256' } rescue ''
    if payload.nil?
      return head 400
    end
    user_id = payload[0]['user_id'] rescue nil
    user = User.find user_id
    if user.nil?
      head 404
    else
      render json: { resource: user }
    end
  end 
end
