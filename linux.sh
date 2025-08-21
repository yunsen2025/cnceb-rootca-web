#!/bin/bash
CERT_URL="https://imgbedcdn.236668.xyz/file/rootCA.crt"
CERT_NAME="rootCA.crt"

# 下载证书到临时目录
curl -o /tmp/$CERT_NAME $CERT_URL

# Debian/Ubuntu 系统
if [ -d /usr/local/share/ca-certificates ]; then
    sudo cp /tmp/$CERT_NAME /usr/local/share/ca-certificates/
    sudo update-ca-certificates
fi

# RHEL/CentOS 系统
if [ -d /etc/pki/ca-trust/source/anchors ]; then
    sudo cp /tmp/$CERT_NAME /etc/pki/ca-trust/source/anchors/
    sudo update-ca-trust
fi

echo "根证书导入完成！"
