class AutoJwt
  def initialize(app)
    @app = app
  end
  def call(env)
    # 获取 header 里的 authorization
    header = env['HTTP_AUTHORIZATION'] 
    # 从authorization获取 jwt
    jwt = header.split(' ')[1] rescue ''
    # 获取解密后的结果 
    payload = JWT.decode jwt, Rails.application.credentials.hmac_secret, true, { algorithm: 'HS256' } rescue nil
    # 拿到 payload 第一部分里的user_id把它放到 env['current_user_id'] 里
    env['current_user_id'] = payload[0]['user_id'] rescue nil
    # 执行我们所有的 controller，@status, @headers, @response 这三个变量是执行每个 controller 给我们返回的
    @status, @headers, @response = @app.call(env)
    [@status, @headers, @response]
  end
end 