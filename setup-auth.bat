@echo off
title Gitee Authentication Setup

echo.
echo =====================================
echo   Gitee Authentication Setup
echo =====================================
echo.

echo Choose authentication method:
echo.
echo [1] Quick Setup - Access Token (Recommended)
echo [2] SSH Key Setup (More secure)
echo [3] View troubleshooting guide
echo.

set /p choice=Select option (1-3): 

if "%choice%"=="1" goto token_setup
if "%choice%"=="2" goto ssh_setup
if "%choice%"=="3" goto troubleshooting
goto token_setup

:token_setup
echo.
echo =====================================
echo   ACCESS TOKEN SETUP
echo =====================================
echo.
echo This is the EASIEST and RECOMMENDED method!
echo.
echo Step 1: Create Access Token
echo ----------------------------------------
echo I will open the Gitee token creation page for you.
echo.
echo On the page:
echo 1. Token description: Enter "Plane Game Deploy"
echo 2. Expiration: Choose "No expiration" or "1 year"
echo 3. Select scopes: Check "projects" (give repository access)
echo 4. Click "Generate token"
echo 5. IMPORTANT: Copy the token immediately (it won't show again!)
echo.
pause
start https://gitee.com/profile/personal_access_tokens
echo.
echo Step 2: How to Use the Token
echo ----------------------------------------
echo After you create the token:
echo 1. Run the deploy script again: deploy-jacksonluoyan.bat
echo 2. Choose option 3 (Access Token)
echo 3. When Git asks for username: jacksonluoyan
echo 4. When Git asks for password: PASTE YOUR ACCESS TOKEN
echo.
echo Your access token replaces your password for Git operations.
echo Save the token somewhere safe for future use!
echo.
goto end

:ssh_setup
echo.
echo =====================================
echo   SSH KEY SETUP
echo =====================================
echo.
echo Step 1: Generate SSH Key
echo ----------------------------------------
echo I'll generate an SSH key for you now.
echo When prompted, just press Enter for default location.
echo You can leave passphrase empty for simplicity.
echo.
pause
ssh-keygen -t rsa -b 4096 -C "14761492+jacksonluoyan@user.noreply.gitee.com"

echo.
echo Step 2: Copy Your Public Key
echo ----------------------------------------
echo Your public key content:
echo.
type %USERPROFILE%\.ssh\id_rsa.pub
echo.
echo The above text has been copied to clipboard (if possible).
echo If not, manually select and copy the text above.
echo.

echo Step 3: Add Key to Gitee
echo ----------------------------------------
echo I will open the Gitee SSH key management page.
echo.
echo On the page:
echo 1. Click "Add SSH Key"
echo 2. Title: Enter "Plane Game Deploy Key"
echo 3. Key: Paste the public key you copied above
echo 4. Click "Add Key"
echo.
pause
start https://gitee.com/profile/sshkeys

echo.
echo Step 4: Test SSH Connection
echo ----------------------------------------
echo Testing SSH connection to Gitee...
ssh -T git@gitee.com

echo.
echo Step 5: Update Git Remote URL
echo ----------------------------------------
echo If SSH test was successful, updating your repository remote URL...
if exist ".git" (
    git remote set-url origin git@gitee.com:jacksonluoyan/plane-game.git
    echo [OK] Remote URL updated to SSH
    echo Now you can run: deploy-jacksonluoyan.bat
) else (
    echo Please run this from your project directory
)
goto end

:troubleshooting
echo.
echo =====================================
echo   TROUBLESHOOTING GUIDE
echo =====================================
echo.
echo Common Push Failure Reasons:
echo.
echo 1. AUTHENTICATION ISSUES:
echo    - Wrong username/password
echo    - Need to use Access Token instead of password
echo    - SSH key not configured
echo.
echo 2. REPOSITORY ISSUES:
echo    - Repository doesn't exist
echo    - No push permissions
echo    - Repository is private and you don't have access
echo.
echo 3. NETWORK ISSUES:
echo    - Internet connection problems
echo    - Firewall blocking Git
echo    - Proxy settings needed
echo.
echo SOLUTIONS:
echo.
echo Solution 1: Use Access Token (EASIEST)
echo - Create token at: https://gitee.com/profile/personal_access_tokens
echo - Use token as password when pushing
echo.
echo Solution 2: Setup SSH Key (MORE SECURE)
echo - Generate key: ssh-keygen -t rsa
echo - Add to Gitee: https://gitee.com/profile/sshkeys
echo - Change remote to SSH: git@gitee.com:jacksonluoyan/plane-game.git
echo.
echo Solution 3: Check Repository
echo - Verify repository exists: https://gitee.com/jacksonluoyan/plane-game
echo - Check if you have push permissions
echo.
echo Want me to open your repository page to check? (y/n)
set /p open_repo=
if /i "%open_repo%"=="y" start https://gitee.com/jacksonluoyan/plane-game
goto end

:end
echo.
echo =====================================
echo.
echo Setup completed! 
echo.
echo Next steps:
echo 1. If you set up Access Token, run: deploy-jacksonluoyan.bat
echo 2. If you set up SSH Key, run: deploy-jacksonluoyan.bat
echo 3. If you need more help, contact support or check Gitee docs
echo.
echo =====================================
pause 