#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

CERT_URL="https://imgbedcdn.236668.xyz/file/rootCA.crt"
CERT_NAME="rootCA.crt"

echo -e "${YELLOW}开始下载根证书...${NC}"

# 下载证书到临时目录
if curl -f -o /tmp/$CERT_NAME $CERT_URL; then
    echo -e "${GREEN}证书下载成功！${NC}"
else
    echo -e "${RED}证书下载失败！${NC}"
    exit 1
fi

echo -e "${YELLOW}正在安装证书...${NC}"

# Debian/Ubuntu 系统
if [ -d /usr/local/share/ca-certificates ]; then
    sudo cp /tmp/$CERT_NAME /usr/local/share/ca-certificates/
    sudo update-ca-certificates
    echo -e "${GREEN}Debian/Ubuntu 系统证书安装完成！${NC}"
fi

# RHEL/CentOS 系统
if [ -d /etc/pki/ca-trust/source/anchors ]; then
    sudo cp /tmp/$CERT_NAME /etc/pki/ca-trust/source/anchors/
    sudo update-ca-trust
    echo -e "${GREEN}RHEL/CentOS 系统证书安装完成！${NC}"
fi

echo -e "${GREEN}根证书导入完成！${NC}"

# 验证证书安装
echo ""
echo -e "${YELLOW}正在验证证书安装...${NC}"

TEST_URL="https://test.ca.ebcn.tech"
if curl -f -s --connect-timeout 10 --max-time 15 "$TEST_URL" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ 证书验证成功！HTTPS 连接正常。${NC}"
else
    echo -e "${RED}❌ 证书验证失败！${NC}"
    echo -e "${YELLOW}可能的原因：${NC}"
    echo -e "${GRAY}  1. 测试网站暂时不可用${NC}"
    echo -e "${GRAY}  2. 证书未正确安装${NC}"
    echo -e "${GRAY}  3. 网络连接问题${NC}"
    echo -e "${GRAY}  4. 需要重启浏览器或重新加载证书存储${NC}"
fi

# 清理临时文件
rm -f /tmp/$CERT_NAME
echo -e "${GRAY}临时文件已清理。${NC}"
