@echo off
echo Starting Expense Tracker Flutter App...
echo.

echo Checking Flutter installation...
flutter doctor
if %ERRORLEVEL% neq 0 (
    echo Flutter is not installed or not in PATH
    echo Please install Flutter first following the README instructions
    pause
    exit /b 1
)

echo.
echo Getting dependencies...
flutter pub get

echo.
echo Running the app...
flutter run

pause
