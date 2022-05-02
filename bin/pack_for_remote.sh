# 注意修改 user 和 ip
user=mangosteen
# 服务器公网 ip
ip=47.99.192.235
# 获取时间戳
time=$(date +'%Y%m%d-%H%M%S')
# 打包文件路径名称
dist=tmp/mangosteen-$time.tar.gz
# 获取当前的目录也就是bin目录
current_dir=$(dirname $0)
# 获取远程的步数目录
deploy_dir=/home/$user/deploys/$time
# 创建一个 gemfile=当前的Gemfile
gemfile=$current_dir/../Gemfile
# 创建爱一个 gemfile_lock
gemfile_lock=$current_dir/../Gemfile.lock
vendor_cache_dir=$current_dir/../vendor/cache
# 帮助函数
function title {
  echo 
  echo "###############################################################################"
  # 打印出 title 函数的第一个参数，title '打包源代码为压缩文件'参数就是'打包源代码为压缩文件'
  echo "## $1"
  echo "###############################################################################" 
  echo 
}
# 删除已经存在的压缩包
yes | rm tmp/mangosteen-*.tar.gz; 

title '打包源代码为压缩文件'
# 把你所有的依赖放到一个 cache 目录然后再打包（这样每次就不用重新下载依赖了）
bundle cache
tar --exclude="tmp/cache/*" -czv -f $dist *
title '创建远程目录'
ssh $user@$ip "mkdir -p $deploy_dir/vendor"
title '上传压缩文件'
# scp(ssh+cp)复制本地文件到远程目录，使用 scp 需要复制到远程的本地文件 user@ip:要上传的目录
scp $dist $user@$ip:$deploy_dir/
scp $gemfile $user@$ip:$deploy_dir/
scp $gemfile_lock $user@$ip:$deploy_dir/
scp -r $vendor_cache_dir $user@$ip:$deploy_dir/vendor/
title '上传 Dockerfile'
scp $current_dir/../config/host.Dockerfile $user@$ip:$deploy_dir/Dockerfile
title '上传 setup 脚本'
scp $current_dir/setup_remote.sh $user@$ip:$deploy_dir/
title '上传版本号'
# 运行远程服务器用户将当前的时间戳写入到 $deploy_dir/version 下
ssh $user@$ip "echo $time > $deploy_dir/version"
title '执行远程脚本'
ssh $user@$ip "export version=$time; /bin/bash $deploy_dir/setup_remote.sh"