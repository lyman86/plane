@echo off
title Gitee Pages Deploy - Plane Game

echo.
echo ====================================
echo   Gitee Pages Deploy - Plane Game
echo ====================================
echo.

REM Check if git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Git is not installed!
    echo.
    echo Please download and install Git first:
    echo https://git-scm.com/download/win
    echo.
    pause
    exit
)

REM Check if index.html exists
if not exist "index.html" (
    echo Error: index.html not found!
    echo Please make sure you are in the project directory.
    echo.
    pause
    exit
)

echo Prerequisites Check:
echo [OK] Git is installed
echo [OK] Project files found
echo.

echo Before proceeding, please ensure:
echo 1. You have a Gitee account (https://gitee.com)
echo 2. You have created a repository named 'plane-game' in Gitee
echo 3. The repository is empty or you want to overwrite it
echo.

set /p username=Enter your Gitee username: 

if "%username%"=="" (
    echo Error: Username cannot be empty!
    pause
    exit
)

REM Set git global config if not set
echo [0/5] Checking Git configuration...
git config --global user.name >nul 2>&1
if %errorlevel% neq 0 (
    echo Setting up Git global configuration...
    git config --global user.name "%username%"
    git config --global user.email "%username%@user.noreply.gitee.com"
    echo [OK] Git configuration set
) else (
    echo [OK] Git already configured
)

echo.
echo Starting deployment for user: %username%
echo Repository: https://gitee.com/%username%/plane-game
echo.

REM Check if this is an existing git repository
if exist ".git" (
    echo [1/5] Found existing Git repository...
    echo [2/5] Adding files to Git...
    git add .
    git status --porcelain >nul 2>&1
    if %errorlevel% equ 0 (
        git commit -m "Update plane game files"
        echo [OK] Files committed
    ) else (
        echo [OK] No changes to commit
    )
    
    echo [3/5] Updating remote repository...
    git remote remove origin >nul 2>&1
    git remote add origin https://gitee.com/%username%/plane-game.git
    echo [OK] Remote repository updated
    
    echo [4/5] Pushing to existing repository...
    git push -u origin master
    
) else (
    echo [1/5] Initializing new Git repository...
    git init
    if %errorlevel% neq 0 (
        echo Error: Failed to initialize Git repository!
        pause
        exit
    )
    echo [OK] Git repository initialized
    
    echo [2/5] Adding files to Git...
    git add .
    git commit -m "Deploy plane game to Gitee Pages"
    echo [OK] Initial commit created
    
    echo [3/5] Adding remote repository...
    git remote add origin https://gitee.com/%username%/plane-game.git
    echo [OK] Remote repository added
    
    echo [4/5] Pushing to Gitee for the first time...
    git push -u origin master
)
echo [5/5] Final deployment step...
echo Note: You may need to enter your Gitee password

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   DEPLOYMENT COMPLETED SUCCESSFULLY!
    echo ========================================
    echo.
    echo Your game repository: https://gitee.com/%username%/plane-game
    echo Your game URL will be: https://%username%.gitee.io/plane-game
    echo.
    echo IMPORTANT: Final steps to activate your website:
    echo 1. Visit: https://gitee.com/%username%/plane-game
    echo 2. Click 'Services' tab at the top
    echo 3. Click 'Gitee Pages'
    echo 4. Select branch: master
    echo 5. Select deploy directory: / (root)
    echo 6. Click 'Start' button
    echo 7. Wait a few minutes for deployment to complete
    echo.
    echo After activation, your game will be available at:
    echo https://%username%.gitee.io/plane-game
    echo.
) else (
    echo.
    echo =====================================
    echo   DEPLOYMENT FAILED
    echo =====================================
    echo.
    echo Possible reasons:
    echo 1. Repository 'plane-game' does not exist in your Gitee account
    echo 2. Incorrect username or password
    echo 3. Network connection issues
    echo.
    echo Solutions:
    echo 1. Create repository 'plane-game' in Gitee first
    echo 2. Check your username and password
    echo 3. Try again or deploy manually
    echo.
    echo Manual deployment guide:
    echo 1. Create repository at: https://gitee.com/new
    echo 2. Repository name: plane-game
    echo 3. Upload all project files to the repository
    echo 4. Enable Gitee Pages in repository settings
    echo.
)

echo.
pause 