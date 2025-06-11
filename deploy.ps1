# 飞机大战游戏 - 自动部署脚本 (PowerShell)
# 适用于Windows系统

param(
    [Parameter(Mandatory=$false)]
    [string]$DeployMethod = "gitee",
    
    [Parameter(Mandatory=$false)]
    [string]$ProjectName = "plane-game",
    
    [Parameter(Mandatory=$false)]
    [string]$GitUsername = "",
    
    [Parameter(Mandatory=$false)]
    [string]$OSSBucket = ""
)

Write-Host "🚀 飞机大战游戏自动部署脚本" -ForegroundColor Green
Write-Host "==============================" -ForegroundColor Green

# 检查必要文件
Write-Host "📋 检查项目文件..." -ForegroundColor Yellow
if (-not (Test-Path "index.html")) {
    Write-Host "❌ 错误：未找到 index.html 文件！" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path "js")) {
    Write-Host "❌ 错误：未找到 js 目录！" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path "css")) {
    Write-Host "❌ 错误：未找到 css 目录！" -ForegroundColor Red
    exit 1
}
Write-Host "✅ 项目文件检查完成" -ForegroundColor Green

# 显示部署选项
Write-Host "`n🎯 请选择部署方式：" -ForegroundColor Cyan
Write-Host "1. Gitee Pages (免费，推荐新手)" -ForegroundColor White
Write-Host "2. GitHub Pages (免费，需要VPN)" -ForegroundColor White
Write-Host "3. 阿里云OSS (收费，推荐)" -ForegroundColor White
Write-Host "4. 腾讯云静态托管 (收费)" -ForegroundColor White

if ($DeployMethod -eq "gitee") {
    $choice = "1"
} else {
    $choice = Read-Host "请输入选择 (1-4)"
}

switch ($choice) {
    "1" {
        Write-Host "`n🌟 选择了 Gitee Pages 部署" -ForegroundColor Green
        Deploy-GiteePages
    }
    "2" {
        Write-Host "`n🌟 选择了 GitHub Pages 部署" -ForegroundColor Green
        Deploy-GitHubPages
    }
    "3" {
        Write-Host "`n🌟 选择了 阿里云OSS 部署" -ForegroundColor Green
        Deploy-AliyunOSS
    }
    "4" {
        Write-Host "`n🌟 选择了 腾讯云静态托管 部署" -ForegroundColor Green
        Deploy-TencentCloud
    }
    default {
        Write-Host "无效选择！" -ForegroundColor Red
        exit 1
    }
}

function Deploy-GiteePages {
    Write-Host "📦 开始 Gitee Pages 部署..." -ForegroundColor Yellow
    
    # 检查 git 是否安装
    try {
        git --version | Out-Null
    } catch {
        Write-Host "❌ 错误：未安装 Git！请先安装 Git。" -ForegroundColor Red
        Write-Host "下载地址：https://git-scm.com/download/win" -ForegroundColor Blue
        exit 1
    }
    
    # 初始化 Git 仓库
    if (-not (Test-Path ".git")) {
        Write-Host "🔧 初始化 Git 仓库..." -ForegroundColor Yellow
        git init
        git add .
        git commit -m "初始化飞机大战游戏项目"
    }
    
    # 获取用户名
    if ($GitUsername -eq "") {
        $GitUsername = Read-Host "请输入您的 Gitee 用户名"
    }
    
    # 添加远程仓库
    $giteeUrl = "https://gitee.com/$GitUsername/$ProjectName.git"
    Write-Host "🔗 添加远程仓库：$giteeUrl" -ForegroundColor Yellow
    
    try {
        git remote add origin $giteeUrl
    } catch {
        Write-Host "⚠️  远程仓库已存在，跳过添加..." -ForegroundColor Yellow
    }
    
    # 推送代码
    Write-Host "📤 推送代码到 Gitee..." -ForegroundColor Yellow
    try {
        git push -u origin master
        Write-Host "✅ 代码推送成功！" -ForegroundColor Green
        
        Write-Host "`n🎉 部署完成！" -ForegroundColor Green
        Write-Host "📱 访问地址：https://$GitUsername.gitee.io/$ProjectName" -ForegroundColor Cyan
        Write-Host "⚙️  请记得在 Gitee 仓库中开启 Pages 服务！" -ForegroundColor Yellow
        Write-Host "`n📋 开启 Pages 服务步骤：" -ForegroundColor Blue
        Write-Host "1. 访问：https://gitee.com/$GitUsername/$ProjectName" -ForegroundColor White
        Write-Host "2. 点击 '服务' -> 'Gitee Pages'" -ForegroundColor White
        Write-Host "3. 选择分支：master，部署目录：/" -ForegroundColor White
        Write-Host "4. 点击 '启动'" -ForegroundColor White
        
    } catch {
        Write-Host "❌ 推送失败！请检查：" -ForegroundColor Red
        Write-Host "1. Gitee 用户名是否正确" -ForegroundColor White
        Write-Host "2. 是否已在 Gitee 创建同名仓库" -ForegroundColor White
        Write-Host "3. 是否已配置 SSH 密钥或输入正确密码" -ForegroundColor White
    }
}

function Deploy-GitHubPages {
    Write-Host "📦 开始 GitHub Pages 部署..." -ForegroundColor Yellow
    Write-Host "⚠️  注意：GitHub 在国内需要 VPN 访问" -ForegroundColor Red
    
    # 类似 Gitee 的流程，但使用 GitHub
    # 这里可以添加 GitHub Pages 的具体实现
    Write-Host "📋 GitHub Pages 部署步骤：" -ForegroundColor Blue
    Write-Host "1. 在 GitHub 创建仓库" -ForegroundColor White
    Write-Host "2. 推送代码到 GitHub" -ForegroundColor White
    Write-Host "3. 在仓库设置中开启 Pages 服务" -ForegroundColor White
}

function Deploy-AliyunOSS {
    Write-Host "📦 开始阿里云 OSS 部署..." -ForegroundColor Yellow
    
    if ($OSSBucket -eq "") {
        $OSSBucket = Read-Host "请输入您的 OSS Bucket 名称"
    }
    
    # 检查 ossutil 是否安装
    try {
        ossutil --version | Out-Null
        Write-Host "✅ 检测到 ossutil 工具" -ForegroundColor Green
        
        # 上传文件
        Write-Host "📤 上传文件到 OSS..." -ForegroundColor Yellow
        ossutil cp -r ./ "oss://$OSSBucket/" --include="*" --exclude=".git/*" --exclude="*.ps1" --exclude="*.md"
        
        Write-Host "✅ 文件上传完成！" -ForegroundColor Green
        Write-Host "📱 访问地址：http://$OSSBucket.oss-cn-hangzhou.aliyuncs.com" -ForegroundColor Cyan
        
    } catch {
        Write-Host "❌ 未检测到 ossutil 工具！" -ForegroundColor Red
        Write-Host "📋 请按以下步骤操作：" -ForegroundColor Blue
        Write-Host "1. 下载 ossutil：https://help.aliyun.com/document_detail/120075.html" -ForegroundColor White
        Write-Host "2. 配置 ossutil：ossutil config" -ForegroundColor White
        Write-Host "3. 重新运行此脚本" -ForegroundColor White
    }
}

function Deploy-TencentCloud {
    Write-Host "📦 腾讯云静态托管部署..." -ForegroundColor Yellow
    Write-Host "📋 请访问腾讯云控制台手动部署：" -ForegroundColor Blue
    Write-Host "https://console.cloud.tencent.com/tcb/hosting" -ForegroundColor Cyan
}

# 优化建议
Write-Host "`n💡 性能优化建议：" -ForegroundColor Blue
Write-Host "1. 压缩 JS/CSS 文件以减少加载时间" -ForegroundColor White
Write-Host "2. 优化图片和音频文件大小" -ForegroundColor White
Write-Host "3. 开启 CDN 加速服务" -ForegroundColor White
Write-Host "4. 配置自定义域名和 HTTPS" -ForegroundColor White

Write-Host "`n🎯 部署脚本执行完成！" -ForegroundColor Green 