@echo off
echo ======================================
echo  Warung Circle - Debug APK Builder v1.0
echo  github: github.com/fajaragrita87-ops/warung-circle
echo ======================================
echo.

:: Check Flutter installed
where flutter >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flutter not found! Install Flutter first: https://flutter.dev
    pause
    exit /b 1
)

:: Set output dir
set OUTPUT_DIR=build\apk-debug
if not exist %OUTPUT_DIR% mkdir %OUTPUT_DIR%

echo [1/4] Getting dependencies...
call flutter pub get
if errorlevel 1 (
    echo [ERROR] pub get failed!
    pause
    exit /b 1
)

echo.
echo [2/4] Cleaning old build...
call flutter clean

echo.
echo [3/4] Building Debug APK (Satu File untuk Semua HP dan Emulator)...
call flutter build apk --debug
if errorlevel 1 (
    echo [ERROR] Build failed! Check errors above.
    pause
    exit /b 1
)

echo.
echo [4/4] Copying debug APK to output folder...
copy /Y build\app\outputs\flutter-apk\app-debug.apk %OUTPUT_DIR%\warung-circle-debug.apk

echo.
echo ======================================
echo  BUILD SUKSES! APK DEBUG TERSEDIA DI:
echo  %OUTPUT_DIR%\warung-circle-debug.apk
echo ======================================
echo.
echo  warung-circle-debug.apk --> Cocok untuk SEMUA jenis HP & Emulator (Satu file serbaguna)
echo.
pause
