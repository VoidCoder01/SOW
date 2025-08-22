@echo off
setlocal enabledelayedexpansion

:MAIN_MENU
cls
echo.
echo ========================================
echo    🚀 Job Dashboard CI/CD Commands
echo ========================================
echo.
echo 📦 Build ^& Test:
echo   1. Build project
echo   2. Run tests
echo   3. Validate HTML
echo   4. Full deployment pipeline
echo   5. Simulate CI/CD pipeline
echo.
echo 🐳 Docker Commands:
echo   6. Build Docker image
echo   7. Run with Docker Compose
echo   8. Stop Docker services
echo.
echo 🧹 Maintenance:
echo   9. Clean project
echo   0. Exit
echo.
echo ========================================
echo.

set /p choice="Enter your choice (0-9): "

if "%choice%"=="1" goto BUILD
if "%choice%"=="2" goto TEST
if "%choice%"=="3" goto VALIDATE
if "%choice%"=="4" goto DEPLOY
if "%choice%"=="5" goto CI_SIMULATE
if "%choice%"=="6" goto DOCKER_BUILD
if "%choice%"=="7" goto DOCKER_RUN
if "%choice%"=="8" goto DOCKER_STOP
if "%choice%"=="9" goto CLEAN
if "%choice%"=="0" goto EXIT
goto MAIN_MENU

:BUILD
echo.
echo 🔨 Building project...
python render_data.py
if %errorlevel% equ 0 (
    echo ✅ Build completed successfully!
) else (
    echo ❌ Build failed!
)
pause
goto MAIN_MENU

:TEST
echo.
echo 🧪 Running tests...
if not exist index.html (
    echo ❌ HTML file is missing
    pause
    goto MAIN_MENU
)

findstr "id=\"total-jobs\">[0-9]" index.html >nul
if errorlevel 1 (
    echo ❌ Total jobs not found in HTML
    pause
    goto MAIN_MENU
)

findstr "id=\"us-jobs\">[0-9]" index.html >nul
if errorlevel 1 (
    echo ❌ US jobs not found in HTML
    pause
    goto MAIN_MENU
)

findstr "id=\"remote-jobs\">[0-9]" index.html >nul
if errorlevel 1 (
    echo ❌ Remote jobs not found in HTML
    pause
    goto MAIN_MENU
)

echo ✅ All tests passed!
pause
goto MAIN_MENU

:VALIDATE
echo.
echo 🔍 Validating HTML output...
python -c "import re; content=open('index.html','r',encoding='utf-8').read(); total=re.search(r'id=\"total-jobs\">(\d+)<',content); us=re.search(r'id=\"us-jobs\">(\d+)<',content); remote=re.search(r'id=\"remote-jobs\">(\d+)<',content); print(f'✅ Validation passed: Total jobs: {total.group(1)}, US jobs: {us.group(1)}, Remote jobs: {remote.group(1)}') if total and us and remote else exit(1)"
if %errorlevel% equ 0 (
    echo ✅ Validation completed successfully!
) else (
    echo ❌ Validation failed!
)
pause
goto MAIN_MENU

:DEPLOY
echo.
echo 🚀 Running full deployment pipeline...
call :BUILD
if %errorlevel% neq 0 goto MAIN_MENU
call :TEST
if %errorlevel% neq 0 goto MAIN_MENU
call :VALIDATE
if %errorlevel% neq 0 goto MAIN_MENU
echo 🎉 Deployment pipeline completed successfully!
pause
goto MAIN_MENU

:CI_SIMULATE
echo.
echo 🔄 Simulating CI/CD pipeline...
echo 🧹 Cleaning project...
del *.log 2>nul
echo ✅ Clean completed!
call :BUILD
if %errorlevel% neq 0 goto MAIN_MENU
call :TEST
if %errorlevel% neq 0 goto MAIN_MENU
call :VALIDATE
if %errorlevel% neq 0 goto MAIN_MENU
echo 🎉 CI/CD simulation completed successfully!
pause
goto MAIN_MENU

:DOCKER_BUILD
echo.
echo 🐳 Building Docker image...
docker build -t job-dashboard .
if %errorlevel% equ 0 (
    echo ✅ Docker image built successfully!
) else (
    echo ❌ Docker build failed!
)
pause
goto MAIN_MENU

:DOCKER_RUN
echo.
echo 🚀 Starting Docker services...
docker-compose up -d
if %errorlevel% equ 0 (
    echo ✅ Services started! Access at http://localhost:8080
) else (
    echo ❌ Failed to start Docker services!
)
pause
goto MAIN_MENU

:DOCKER_STOP
echo.
echo 🛑 Stopping Docker services...
docker-compose down
if %errorlevel% equ 0 (
    echo ✅ Services stopped!
) else (
    echo ❌ Failed to stop Docker services!
)
pause
goto MAIN_MENU

:CLEAN
echo.
echo 🧹 Cleaning project...
del *.log 2>nul
echo ✅ Clean completed!
pause
goto MAIN_MENU

:EXIT
echo.
echo 👋 Goodbye! Thanks for using the CI/CD tools.
echo.
exit /b 0
