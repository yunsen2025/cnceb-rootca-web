# 确保以管理员权限运行
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "请以管理员身份运行此脚本！" -ForegroundColor Red
    Write-Host "按任意键退出..."
    [void][System.Console]::ReadKey($true)
    exit 1
}

$certUrl = "https://imgbedcdn.236668.xyz/file/rootCA.crt"
$tempFile = "$env:TEMP\rootCA.crt"

Write-Host "开始下载根证书..." -ForegroundColor Yellow

try {
    # 下载证书
    Invoke-WebRequest -Uri $certUrl -OutFile $tempFile -ErrorAction Stop
    Write-Host "证书下载成功！" -ForegroundColor Green
    
    # 导入到本地受信任根证书存储
    Write-Host "正在导入证书到受信任根证书存储..." -ForegroundColor Yellow
    Import-Certificate -FilePath $tempFile -CertStoreLocation Cert:\LocalMachine\Root -ErrorAction Stop
    
    Write-Host "根证书导入完成！" -ForegroundColor Green
    Write-Host "证书已成功安装到系统中。" -ForegroundColor Green
    
    # 清理临时文件
    if (Test-Path $tempFile) {
        Remove-Item $tempFile -Force
        Write-Host "临时文件已清理。" -ForegroundColor Gray
    }
}
catch {
    Write-Host "操作失败：$($_.Exception.Message)" -ForegroundColor Red
    Write-Host "请检查网络连接或联系管理员。" -ForegroundColor Red
}
finally {
    Write-Host ""
    Write-Host "按任意键退出..."
    [void][System.Console]::ReadKey($true)
}
