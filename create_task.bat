@echo off
setlocal EnableDelayedExpansion

REM --- 1. Project Name ---
set /p "projName=Enter new project name (e.g., spi, i2c): "

if "%projName%"=="" (
    echo [ERROR] Project name cannot be empty.
    goto :EOF
)

if exist "%projName%" (
    echo [ERROR] Folder "%projName%" already exists!
    goto :EOF
)

echo.
echo Creating project: %projName%...

REM --- 2. Directory Structure ---
mkdir "%projName%"
mkdir "%projName%\src"
mkdir "%projName%\src\rtl"
mkdir "%projName%\src\verif"
mkdir "%projName%\src\scripts"

REM --- 3. Copy Scripts ---


echo Copying scripts...
if exist "test\src\scripts\run.bat" (
    copy "test\src\scripts\run.bat" "%projName%\src\scripts\" >nul
) else (
    echo [WARNING] Could not find run.bat in test\src\scripts\
)

if exist "test\setup.ps1" (
    copy "test\setup.ps1" "%projName%\" >nul
) else (
    echo [WARNING] Could not find setup.ps1 in test\
)

if exist "test\src\scripts\open_waves.bat" (
    copy "test\src\scripts\open_waves.bat" "%projName%\src\scripts\" >nul
) else (
    echo [WARNING] Could not find open_waves.bat in test\src\scripts\
)

REM --- 4. Create a default filelist.f ---
echo // Add your RTL and TB file paths here > "%projName%\files_tb.f"
echo // Example: src/rtl/my_design.sv >> "%projName%\files_tb.f"

echo.
echo ========================================================
echo  SUCCESS! Project "%projName%" created.
echo ========================================================
echo  Next Steps:
echo  1. Put your RTL in: %projName%\src\rtl
echo  2. Put your TB in:  %projName%\src\verif
echo  3. Update file list: %projName%\files_tb.f
echo  4. Edit TOP_MODULE in: %projName%\src\scripts\run.bat
echo ========================================================
pause