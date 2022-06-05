class UserMailer < ApplicationMailer
  def welcome_email(code)
    @code = code
    mail(to: "wanglifa1995@qq.com", subject: '周杰伦')
  end
end
