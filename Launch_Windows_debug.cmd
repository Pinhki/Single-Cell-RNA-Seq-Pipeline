@echo off
setlocal EnableExtensions
set "ROOT=%~dp0"
set "LOG=%TEMP%\Launch_Windows_debug.log"

echo ==========================================================> "%LOG%"
echo Launch_Windows_debug started %DATE% %TIME%>> "%LOG%"
echo ROOT=%ROOT%>> "%LOG%"
echo ==========================================================>> "%LOG%"

pushd "%ROOT%" >nul 2>nul
if errorlevel 1 (
  echo.
  echo [DEBUG] pushd failed for: %ROOT%
  echo [DEBUG] pushd failed for: %ROOT%>> "%LOG%"
  echo [DEBUG] Log: %LOG%
  echo.
  pause
  exit /b 1
)

call .\Launch_Windows.bat >> "%LOG%" 2>&1
set "RC=%ERRORLEVEL%"

echo.>> "%LOG%"
echo [DEBUG] Finished. ExitCode=%RC%>> "%LOG%"

echo.
echo [DEBUG] Finished. ExitCode=%RC%
echo [DEBUG] Log: %LOG%
echo.
pause
exit /b %RC%
