@echo off
echo ======================================
echo  Warung Circle - APK Builder v1.0
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
set OUTPUT_DIR=build\apk-release
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
echo [3/4] Building APK (release)...
call flutter build apk --release --split-per-abi
if errorlevel 1 (
    echo [ERROR] Build failed! Check errors above.
    pause
    exit /b 1
)

echo.
echo [4/4] Copying APKs to output folder...
copy /Y build\app\outputs\flutter-apk\app-arm64-v8a-release.apk %OUTPUT_DIR%\warung-circle-arm64.apk
copy /Y build\app\outputs\flutter-apk\app-armeabi-v7a-release.apk %OUTPUT_DIR%\warung-circle-arm32.apk
copy /Y build\app\outputs\flutter-apk\app-x86_64-release.apk %OUTPUT_DIR%\warung-circle-x86.apk

echo.
echo ======================================
echo  BUILD SUKSES! APK tersedia di:
echo  %OUTPUT_DIR%\
echo ======================================
echo.
echo  warung-circle-arm64.apk   --> HP Modern (kebanyakan HP 2020+)
echo  warung-circle-arm32.apk   --> HP Lama
echo  warung-circle-x86.apk     --> Emulator / Desktop
echo.
pause
