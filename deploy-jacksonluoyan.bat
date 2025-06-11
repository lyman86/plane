@echo off
title Quick Deploy - JacksonLuoyan/plane-game

echo.
echo ==========================================
echo   Quick Deploy for JacksonLuoyan
echo   Repository: plane-game
echo ==========================================
echo.

REM Check if git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Git is not installed!
    echo Please download and install Git first:
    echo https://git-scm.com/download/win
    pause
    exit
)

REM Check if index.html exists
if not exist "index.html" (
    echo Error: index.html not found!
    echo Please make sure you are in the project directory.
    pause
    exit
)

echo [OK] Git is installed
echo [OK] Project files found
echo.

REM Set git global config (based on your Gitee info)
echo [1/6] Setting up Git configuration...
git config --global user.name "JacksonLuoyan"
git config --global user.email "14761492+jacksonluoyan@user.noreply.gitee.com"
echo [OK] Git configuration set

REM Check if this is an existing git repository
if exist ".git" (
    echo [2/6] Found existing Git repository...
    
    echo [3/6] Adding updated files...
    git add .
    
    echo [4/6] Committing changes...
    git commit -m "Update plane game - %date% %time%"
    if %errorlevel% neq 0 (
        echo [OK] No changes to commit
    )
    
    echo [5/6] Updating remote repository...
    git remote remove origin >nul 2>&1
    git remote add origin https://gitee.com/jacksonluoyan/plane-game.git
    
) else (
    echo [2/6] Initializing new Git repository...
    git init
    
    echo [3/6] Adding all files...
    git add .
    
    echo [4/6] Creating initial commit...
    git commit -m "Deploy plane game to Gitee Pages"
    
    echo [5/6] Adding remote repository...
    git remote add origin https://gitee.com/jacksonluoyan/plane-game.git
)

echo [6/6] Pushing to Gitee...
echo.
echo AUTHENTICATION OPTIONS:
echo [1] Username + Password (Simple)
echo [2] I want to setup SSH key (More secure)
echo [3] Use Access Token (Recommended)
echo.
set /p auth_choice=Choose authentication method (1-3): 

if "%auth_choice%"=="1" goto password_auth
if "%auth_choice%"=="2" goto ssh_auth
if "%auth_choice%"=="3" goto token_auth
goto password_auth

:password_auth
echo.
echo Using Username + Password authentication...
echo Note: Please enter your Gitee password when prompted
echo If this fails, try option 3 (Access Token)
echo.
git push -u origin master
goto check_result

:ssh_auth
echo.
echo =====================================
echo   SSH KEY SETUP GUIDE
echo =====================================
echo.
echo To setup SSH key authentication:
echo.
echo 1. Generate SSH key (run this command):
echo    ssh-keygen -t rsa -C "14761492+jacksonluoyan@user.noreply.gitee.com"
echo.
echo 2. Copy your public key (run this command):
echo    type %USERPROFILE%\.ssh\id_rsa.pub
echo.
echo 3. Add the key to Gitee:
echo    - Visit: https://gitee.com/profile/sshkeys
echo    - Click "Add SSH Key"
echo    - Paste your public key
echo    - Save
echo.
echo 4. Change remote URL to SSH:
echo    git remote set-url origin git@gitee.com:jacksonluoyan/plane-game.git
echo.
echo 5. Try push again:
echo    git push -u origin master
echo.
echo Would you like me to open the SSH key management page? (y/n)
set /p open_ssh=
if /i "%open_ssh%"=="y" start https://gitee.com/profile/sshkeys
goto end_without_push

:token_auth
echo.
echo =====================================
echo   ACCESS TOKEN SETUP (RECOMMENDED)
echo =====================================
echo.
echo Step 1: Create Access Token
echo 1. Visit: https://gitee.com/profile/personal_access_tokens
echo 2. Click "Generate new token"
echo 3. Token description: "Plane Game Deploy"
echo 4. Select scopes: Check "projects" (or "repo")
echo 5. Click "Create Token"
echo 6. COPY the token (it won't show again!)
echo.
echo Step 2: Use Token for Authentication
echo When prompted for password, use your ACCESS TOKEN instead
echo Username: jacksonluoyan
echo Password: [paste your access token]
echo.
echo Would you like me to open the token creation page? (y/n)
set /p open_token=
if /i "%open_token%"=="y" start https://gitee.com/profile/personal_access_tokens
echo.
echo Press any key when you have your token ready...
pause >nul
echo.
echo Now pushing with token authentication...
echo When prompted, use your ACCESS TOKEN as password
echo.
git push -u origin master
goto check_result

:check_result

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   DEPLOYMENT SUCCESSFUL!
    echo ========================================
    echo.
    echo Repository: https://gitee.com/jacksonluoyan/plane-game
    echo Future URL: https://jacksonluoyan.gitee.io/plane-game
    echo.
    echo NEXT STEPS - Enable Gitee Pages:
    echo 1. Open: https://gitee.com/jacksonluoyan/plane-game
    echo 2. Click the "Services" tab
    echo 3. Click "Gitee Pages"
    echo 4. Select:
    echo    - Branch: master
    echo    - Directory: / (root)
    echo 5. Click "Start" button
    echo 6. Wait 2-5 minutes for activation
    echo.
    echo After activation, your game will be live at:
    echo https://jacksonluoyan.gitee.io/plane-game
    echo.
    echo Want to open Gitee repository now? (y/n)
    set /p open=
    if /i "%open%"=="y" start https://gitee.com/jacksonluoyan/plane-game
    if /i "%open%"=="yes" start https://gitee.com/jacksonluoyan/plane-game
    
) else (
    echo.
    echo =====================================
    echo   DEPLOYMENT FAILED
    echo =====================================
    echo.
    echo Possible solutions:
    echo 1. Check your internet connection
    echo 2. Verify your Gitee password
    echo 3. Make sure repository exists at:
    echo    https://gitee.com/jacksonluoyan/plane-game
    echo.
    echo If repository doesn't exist, create it at:
    echo https://gitee.com/new
    echo Repository name: plane-game
    echo.
    echo AUTHENTICATION TROUBLESHOOTING:
    echo Try these solutions:
    echo 1. Use Access Token instead of password
    echo 2. Setup SSH key authentication
    echo 3. Check if repository exists and you have access
    echo.
)

:end_without_push
echo.
echo Setup completed. Please run the script again after configuring authentication.
pause
exit

echo.
echo ========================================
echo.
echo Quick Commands for Future Updates:
echo.
echo To update your game later, just run this script again
echo or use these commands in your project folder:
echo.
echo   git add .
echo   git commit -m "Update game"
echo   git push origin master
echo.
echo Then refresh your Gitee Pages in the repository settings.
echo.
echo ========================================
pause 