# 确保以管理员权限运行
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "请以管理员身份运行此脚本！"
    exit
}

$certUrl = "https://imgbedcdn.236668.xyz/file/rootCA.crt"
$tempFile = "$env:TEMP\rootCA.crt"

# 下载证书
Invoke-WebRequest -Uri $certUrl -OutFile $tempFile

# 导入到本地受信任根证书存储
Import-Certificate -FilePath $tempFile -CertStoreLocation Cert:\LocalMachine\Root

Write-Host "根证书导入完成！"
