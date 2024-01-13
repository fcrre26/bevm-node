#!/bin/bash

# 询问用户选择节点名称的方式
read -p "请选择节点名称方式：1. 随机节点名称（回车默认） 2. 手工输入节点名称 " OPTION

if [ "$OPTION" = "2" ]; then
    read -p "请输入节点名称: " NODE_NAME
else
    NODE_NAME="随机节点名字$(date +%s)"
fi

# 输出节点名字到文档
echo $NODE_NAME > node_name.txt

# 下载文件
wget https://github.com/btclayer2/BEVM/releases/download/testnet-v0.1.1/bevm-v0.1.1-ubuntu20.04

# 赋予执行权限
chmod +x bevm-v0.1.1-ubuntu20.04

# 使用supervisord来启动进程
cat <<EOF > /etc/supervisor/conf.d/bevm.conf
[program:bevm]
command=/root/bevm-v0.1.1-ubuntu20.04 --chain=testnet --name="$NODE_NAME" --pruning=archive
autostart=true
autorestart=true
stderr_logfile=/var/log/bevm.err.log
stdout_logfile=/var/log/bevm.out.log
EOF

# 重新加载supervisord配置
supervisorctl reread
supervisorctl update