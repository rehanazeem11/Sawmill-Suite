@echo off
set "JAVA_HOME=C:\Program Files\Microsoft\jdk-21.0.12.101-hotspot"
set "ANDROID_SDK_ROOT=%LOCALAPPDATA%\Android\Sdk"
cd /d "%~dp0android"
call gradlew.bat assembleDebug
echo.
echo Build complete!
echo APK location: %~dp0android\app\build\outputs\apk\debug\app-debug.apk
