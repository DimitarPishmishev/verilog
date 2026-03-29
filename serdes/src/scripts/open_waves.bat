@echo off
setlocal enabledelayedexpansion

:: --- DYNAMIC PATH RESOLUTION (Must be at the top!) ---
:: 1. Get script dir before shift destroys %0
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

:: 2. Move up two levels from scripts -> src -> UART
for %%I in ("%SCRIPT_DIR%\..\..") do set "ROOT_DIR=%%~fI"

:: --- CONFIG ---
set "OUT_DIR_NAME=out"
set "VIEWER=vivado"

:: --- ARGUMENT PARSING ---
:parse_args
if "%~1"=="" goto end_parse
if "%~1"=="-s" (
    set "VIEWER=surfer"
    shift
    goto parse_args
)
:: Check if argument is likely a custom folder name (doesn't start with -)
if not "%~1"=="" (
    if not "%~1:~0,1%"=="-" (
        set "OUT_DIR_NAME=out_%~1"
    )
)
shift
goto parse_args
:end_parse

:: --- EXECUTION ---
set "OUT_DIR=%ROOT_DIR%\%OUT_DIR_NAME%"

if not exist "%OUT_DIR%" (
    echo [ERROR] Output directory '%OUT_DIR%' not found!
    echo Run your simulation script first.
    exit /b 1
)

pushd "%OUT_DIR%"

if "%VIEWER%"=="surfer" (
    echo Opening Surfer for %OUT_DIR_NAME%...
    if exist "dump.vcd" (
        start surfer dump.vcd
    ) else (
        echo [ERROR] dump.vcd not found. Did you run the simulation with the -s flag?
    )
) else (
    echo Opening Vivado Waveform Viewer for %OUT_DIR_NAME%...
    if exist "my_snapshot.wdb" (
        call xsim my_snapshot.wdb -gui
    ) else if exist "xsim.wdb" (
        call xsim xsim.wdb -gui
    ) else (
        echo [WARNING] No .wdb file found! Loading the snapshot instead...
        call xsim my_snapshot -gui
    )
)

popd