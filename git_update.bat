@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo             Panchforon Git Update Script
echo ===================================================
echo.

:: Check if git is installed
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Git is not installed or not added to your PATH environment variable.
    echo Please install Git and try again.
    goto end
)

:: Git Status
echo Checking local git status...
git status -s
echo.

:: Stage all changes
echo Staging all changes...
git add -A
if %errorlevel% neq 0 (
    echo [ERROR] Failed to stage changes.
    goto end
)

:: Prompt for commit message
echo.
set /p commit_msg="Enter commit message (Press Enter for default 'update'): "
if "%commit_msg%"=="" (
    :: Get current date and time
    for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
    set cur_date=!datetime:~0,4!-!datetime:~4,2!-!datetime:~6,2!
    set cur_time=!datetime:~8,2!:!datetime:~10,2!
    set commit_msg=Update code - !cur_date! !cur_time!
)

echo.
echo Committing changes with message: "%commit_msg%"
git commit -m "%commit_msg%"
if %errorlevel% neq 0 (
    echo [INFO] No changes to commit or commit failed.
)

:: Pull first to ensure no conflicts
echo.
echo Pulling latest changes from remote...
git pull origin main
if %errorlevel% neq 0 (
    echo [WARNING] Pull failed or there are conflicts. If this is a new repository, this is normal.
)

:: Push changes
echo.
echo Pushing changes to remote main branch...
git push origin main
if %errorlevel% neq 0 (
    echo [ERROR] Push failed. Please check your internet connection or Git credentials.
) else (
    echo.
    echo ===================================================
    echo             Successfully Updated!
    echo ===================================================
)

:end
echo.
pause
