class UserMailer < ApplicationMailer
  def welcome_email(email)
    # 通过 created_at 创建时间排序 :desc 最大的排在最前面
    validation_code = ValidationCode.order(created_at: :desc).find_by_email(email)
    @code = validation_code.code
    mail(to: email, subject: '山竹记账验证码')
  end
end