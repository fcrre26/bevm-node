#!/bin/bash

# 询问用户选择节点名称的方式
read -p "请选择节点名称方式：1. 随机节点名称（回车默认） 
2. 手工输入节点名称 " OPTION


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

# 创建 systemd unit 文件
cat <<EOF > /etc/systemd/system/bevm.service
[Unit]
Description=BEVM Node
After=network.target

[Service]
User=your_username
WorkingDirectory=/path/to/your/bevm/directory
ExecStart=/path/to/your/bevm/directory/bevm-v0.1.1-ubuntu20.04 --chain=testnet --name="$NODE_NAME" --pruning=archive
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=bevm

[Install]
WantedBy=multi-user.target
EOF

# 启动服务并设置开机自启动
systemctl start bevm
systemctl enable bevm
