@echo off
title Plane Game Deploy Tool

echo.
echo ================================
echo   Plane Game Deploy Tool
echo ================================
echo.

echo Deploy Options:
echo.
echo [1] Gitee Pages (Free, Recommended)
echo     - Completely free
echo     - Fast access in China
echo     - Custom domain support
echo.
echo [2] Aliyun OSS (Paid, ~15 RMB/month)
echo     - Fastest access speed
echo     - Highest stability
echo     - Auto CDN acceleration
echo.
echo [3] View detailed documentation
echo.
echo [4] Manual upload guide
echo.

set /p choice=Please select deploy method (1-4): 

if "%choice%"=="1" goto gitee
if "%choice%"=="2" goto oss
if "%choice%"=="3" goto docs
if "%choice%"=="4" goto manual
goto invalid

:gitee
echo.
echo Selected: Gitee Pages Deploy
echo.
echo Prerequisites:
echo 1. Install Git: https://git-scm.com/download/win
echo 2. Register Gitee account: https://gitee.com
echo 3. Create repository named 'plane-game' in Gitee
echo.
pause
echo.
echo Starting deployment...

REM Check if git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Git is not installed!
    echo Please download and install Git first.
    echo Download: https://git-scm.com/download/win
    pause
    goto end
)

REM Check if index.html exists
if not exist "index.html" (
    echo Error: index.html not found!
    echo Please make sure you are in the correct project directory.
    pause
    goto end
)

REM Initialize git repository if not exists
if not exist ".git" (
    echo Initializing Git repository...
    git init
    git add .
    git commit -m "Initial commit for plane game"
)

REM Get username
set /p username=Enter your Gitee username: 

REM Add remote origin
echo Adding remote repository...
git remote add origin https://gitee.com/%username%/plane-game.git 2>nul

REM Push to gitee
echo Pushing code to Gitee...
git push -u origin master

if %errorlevel% equ 0 (
    echo.
    echo Deploy completed successfully!
    echo.
    echo Your game URL: https://%username%.gitee.io/plane-game
    echo.
    echo Next steps:
    echo 1. Visit: https://gitee.com/%username%/plane-game
    echo 2. Click 'Services' - 'Gitee Pages'
    echo 3. Select branch: master, deploy directory: /
    echo 4. Click 'Start'
) else (
    echo.
    echo Deploy failed! Please check:
    echo 1. Gitee username is correct
    echo 2. Repository 'plane-game' exists in Gitee
    echo 3. SSH key is configured or enter password correctly
)

goto end

:oss
echo.
echo Selected: Aliyun OSS Deploy
echo.
echo Prerequisites:
echo 1. Register Aliyun account: https://www.aliyun.com
echo 2. Enable OSS service
echo 3. Download and configure ossutil tool
echo.
echo For detailed steps, please check deploy.md
pause
goto end

:docs
echo.
echo Opening detailed documentation...
start deploy.md
goto menu

:manual
echo.
echo Manual Upload Guide
echo ===================
echo.
echo Gitee Pages Manual Upload:
echo 1. Visit https://gitee.com and login
echo 2. Create new repository named: plane-game
echo 3. Upload these files to repository:
echo    - index.html (required)
echo    - js/ folder (required)
echo    - css/ folder (required)
echo    - audio/ folder (optional)
echo 4. In repository page, click 'Services' - 'Gitee Pages'
echo 5. Select branch: master, deploy directory: /
echo 6. Click 'Start'
echo.
echo Aliyun OSS Manual Upload:
echo 1. Login to Aliyun console
echo 2. Go to Object Storage OSS
echo 3. Create Bucket with 'Public Read' permission
echo 4. Enable static website hosting
echo 5. Upload all project files
echo 6. Access via Bucket external URL
echo.
pause
goto menu

:invalid
echo.
echo Invalid selection! Please try again.
timeout /t 2 >nul
goto menu

:end
echo.
echo Deploy process completed!
echo.
echo Tips:
echo - First deployment may take a few minutes to take effect
echo - Check deploy.md for troubleshooting
echo - Recommend configuring custom domain for better experience
echo.

:menu
echo.
set /p restart=Do you want to select another deploy method? (y/n): 
if /i "%restart%"=="y" goto start
if /i "%restart%"=="yes" goto start

echo.
echo Thank you for using the deploy tool!
pause >nul
exit

:start
cls
goto begin

:begin
echo.
echo ================================
echo   Plane Game Deploy Tool
echo ================================
echo.

echo Deploy Options:
echo.
echo [1] Gitee Pages (Free, Recommended)
echo     - Completely free
echo     - Fast access in China
echo     - Custom domain support
echo.
echo [2] Aliyun OSS (Paid, ~15 RMB/month)
echo     - Fastest access speed
echo     - Highest stability
echo     - Auto CDN acceleration
echo.
echo [3] View detailed documentation
echo.
echo [4] Manual upload guide
echo.

set /p choice=Please select deploy method (1-4): 

if "%choice%"=="1" goto gitee
if "%choice%"=="2" goto oss
if "%choice%"=="3" goto docs
if "%choice%"=="4" goto manual
goto invalid 