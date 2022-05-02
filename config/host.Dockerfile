FROM ruby:3.0.0

# 设置环境变量为生产环境
ENV RAILS_ENV production
# 创建一个根目录下的mangosteen文件用来放我们的代码
RUN mkdir /mangosteen
# 将我们的 ruby 镜像改成中国的
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com
# 设置工作目录为 /mangosteen
WORKDIR /mangosteen
# 把最新打包压缩的宝添加到当前目录（ADD命令会自动解压缩 tar 包）
ADD mangosteen-*.tar.gz ./
# 安装除dev和test环境之外的包
RUN bundle config set --local without 'development test'
# 直接从本地安装
RUN bundle install --local
# 启动服务(rails server 是专门运行开发环境的，puma运行生产环境)
# 这里之所以不用 RUN，是因为我们不需要立即运行，只有当你运行 docker run 的时候，才会帮我们开启服务
ENTRYPOINT bundle exec puma