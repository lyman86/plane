@echo off
chcp 65001 >nul
title 飞机大战游戏 - 一键部署工具

echo.
echo 🚀 飞机大战游戏 - 一键部署工具
echo ==============================
echo.

echo 🎯 快速部署选项：
echo.
echo [1] Gitee Pages (免费，推荐新手)
echo     ✅ 完全免费
echo     ✅ 国内访问速度快
echo     ✅ 支持自定义域名
echo.
echo [2] 阿里云OSS (推荐，约15元/月)
echo     ✅ 访问速度最快
echo     ✅ 稳定性最高
echo     ✅ 自动CDN加速
echo.
echo [3] 查看详细部署文档
echo.
echo [4] 手动上传指导
echo.

set /p choice=请选择部署方式 (1-4): 

if "%choice%"=="1" goto gitee
if "%choice%"=="2" goto oss
if "%choice%"=="3" goto docs
if "%choice%"=="4" goto manual
goto invalid

:gitee
echo.
echo 🌟 选择了 Gitee Pages 部署
echo.
echo 📋 准备工作：
echo 1. 确保已安装 Git
echo    下载地址: https://git-scm.com/download/win
echo 2. 注册 Gitee 账号
echo    注册地址: https://gitee.com
echo 3. 在 Gitee 创建名为 plane-game 的仓库
echo.
pause
echo.
echo 🔧 开始部署...
powershell.exe -ExecutionPolicy Bypass -File "deploy.ps1" -DeployMethod "gitee"
goto end

:oss
echo.
echo 🌟 选择了阿里云OSS部署
echo.
echo 📋 准备工作：
echo 1. 注册阿里云账号
echo    注册地址: https://www.aliyun.com
echo 2. 开通OSS服务
echo 3. 下载并配置 ossutil 工具
echo.
echo 💡 详细步骤请查看 deploy.md 文档
pause
echo.
echo 🔧 开始部署...
powershell.exe -ExecutionPolicy Bypass -File "deploy.ps1" -DeployMethod "oss"
goto end

:docs
echo.
echo 📖 正在打开详细部署文档...
start deploy.md
goto menu

:manual
echo.
echo 📋 手动上传指导
echo ================
echo.
echo 🎯 Gitee Pages 手动上传：
echo 1. 访问 https://gitee.com 并登录
echo 2. 创建新仓库，名称为：plane-game
echo 3. 将以下文件上传到仓库：
echo    - index.html (必需)
echo    - js/ 文件夹 (必需)
echo    - css/ 文件夹 (必需)
echo    - audio/ 文件夹 (可选，音效文件)
echo 4. 在仓库页面点击 "服务" -> "Gitee Pages"
echo 5. 选择分支：master，部署目录：/
echo 6. 点击 "启动"
echo.
echo 🎯 阿里云OSS 手动上传：
echo 1. 登录阿里云控制台
echo 2. 进入对象存储OSS
echo 3. 创建Bucket，读写权限设为"公共读"
echo 4. 开启静态网站托管功能
echo 5. 上传所有项目文件
echo 6. 访问Bucket的外网地址
echo.
pause
goto menu

:invalid
echo.
echo ❌ 无效选择，请重新选择！
timeout /t 2 >nul
goto menu

:end
echo.
echo 🎉 部署流程完成！
echo.
echo 💡 温馨提示：
echo - 首次部署可能需要等待几分钟生效
echo - 如遇问题请查看 deploy.md 详细文档
echo - 建议配置自定义域名以获得更好体验
echo.

:menu
echo.
set /p restart=是否需要重新选择部署方式？(y/n): 
if /i "%restart%"=="y" goto start
if /i "%restart%"=="yes" goto start

echo.
echo 👋 感谢使用一键部署工具！
pause >nul
exit

:start
cls
goto begin

:begin
echo.
echo 🚀 飞机大战游戏 - 一键部署工具
echo ==============================
echo.

echo 🎯 快速部署选项：
echo.
echo [1] Gitee Pages (免费，推荐新手)
echo     ✅ 完全免费
echo     ✅ 国内访问速度快
echo     ✅ 支持自定义域名
echo.
echo [2] 阿里云OSS (推荐，约15元/月)
echo     ✅ 访问速度最快
echo     ✅ 稳定性最高
echo     ✅ 自动CDN加速
echo.
echo [3] 查看详细部署文档
echo.
echo [4] 手动上传指导
echo.

set /p choice=请选择部署方式 (1-4): 

if "%choice%"=="1" goto gitee
if "%choice%"=="2" goto oss
if "%choice%"=="3" goto docs
if "%choice%"=="4" goto manual
goto invalid 