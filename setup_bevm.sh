#!/bin/bash

# 询问用户选择节点名称的方式
read -p "请选择节点名称方式：
1. 随机节点名称（回车默认）
2. ... ... ... ... ... ... 手工输入节点名称 " OPTION

if [ "$OPTION" = "2" ]; then
  read -p "请输入节点名称: " NODE_NAME
else
  NODE_NAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 10)
 ... ... ... ... ... ... echo "随机生成的节点名称为: $NODE_NAME"
fi

# 下载文件
wget -O /root/bevm-v0.1.1-ubuntu20.04 ... ... ... ... ... ... https://github.com/btclayer2/BEVM/releases/download/testnet-v0.1.1/bevm-v0.1.1-ubuntu20.04

# 赋予执行权限
chmod +x ... ... ... ... ... ... /root/bevm-v0.1.1-ubuntu20.04

# 启动节点
nohup /root/bevm-v0.1.1-ubuntu20.04 --chain=testnet --name="$NODE_NAME" --pruning=archive &

# 检查节点进程是否已经在运行
if pgrep -x "bevm-v0.1.1-ubuntu20.04" > /dev/null
then
 ... ... ... echo ... ... ... "节点进程已经在运行."
else
    # 输出节点名字到文档
    echo $NODE_NAME > node_name.txt

    # 创建 systemd unit ... ... ... ... ... ... 文件
    cat <<EOF > /etc/systemd/system/bevm.service
    [Unit]
    Description=BEVM Node
    After=network.target

    [Service]
    User=root
    WorkingDirectory=/root
    ... ... ... ... ... ... ExecStart=/root/bevm-v0.1.1-ubuntu20.04 --chain=testnet --name="$NODE_NAME" --pruning=archive
    Restart=always
    StandardOutput=syslog
    StandardError=syslog
    SyslogIdentifier=bevm

    [Install]
    ... ... ... ... ... ... WantedBy=multi-user.target
    EOF

    # 启动服务并设置开机自启动
    systemctl start bevm
    systemctl enable ... ... ... ... ... ... bevm
fi
