@echo off
setlocal enabledelayedexpansion

:: 1. Dynamically resolve absolute paths 
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

:: Move up two levels from scripts -> src -> UART
for %%I in ("%SCRIPT_DIR%\..\..") do set "PROJECT_ROOT=%%~fI"

set "RTL_DIR=%PROJECT_ROOT%\src\rtl"
set "VERIF_DIR=%PROJECT_ROOT%\src\verif"
set "FILE_LIST=%PROJECT_ROOT%\files_tb.f"

:: 2. Set default variables
set "SKIP_SCAN=0"
set "OUT_DIR_NAME=out"
set "TOP_MODULE=tb_top"
set "GEN_VCD=0"

:: 3. Parse arguments
:parse_args
if "%~1"=="" goto end_parse
if "%~1"=="-r" (
    set "SKIP_SCAN=1"
    shift
    goto parse_args
)
if "%~1"=="-s" (
    set "GEN_VCD=1"
    shift
    goto parse_args
)
if "%~1"=="-o" (
    set "OUT_DIR_NAME=out_%~2"
    shift
    shift
    goto parse_args
)
if "%~1"=="-t" (
    set "TOP_MODULE=%~2"
    shift
    shift
    goto parse_args
)
if "%~1"=="-h" (
    echo Usage: %~nx0 [-r] [-s] [-o suffix] [-t top_module]
    echo   -r         : Read directly from files_tb.f without scanning for new files
    echo   -s         : Generate a .vcd file for Surfer instead of a Vivado .wdb
    echo   -o suffix  : Create a custom output dir ^(e.g., '-o test' creates 'out_test'^)
    echo   -t top_mod : Specify the top module name for elaboration ^(default: tb_top^)
    exit /b 0
)
echo Unknown parameter passed: %~1
exit /b 1
:end_parse

set "OUT_DIR=%PROJECT_ROOT%\%OUT_DIR_NAME%"

if "%SKIP_SCAN%"=="0" (
    call :create_list
) else (
    echo Skipping file scan ^(-r used^). Reading directly from %FILE_LIST%.
)

if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"
cd /d "%OUT_DIR%"

echo --- Starting Vivado Simulation in %OUT_DIR_NAME% ---

echo [1/3] Compiling...
call xvlog -sv -f "%FILE_LIST%" -L uvm
if errorlevel 1 (
    echo Compilation failed!
    exit /b 1
)

:: 7. Elaborate (xelab)
echo [2/3] Elaborating...
call xelab -debug typical -top "%TOP_MODULE%" -snapshot my_snapshot -L uvm
if errorlevel 1 (
    echo Elaboration failed!
    exit /b 1
)

:: 8. Simulate (xsim)
echo [3/3] Simulating...
if "%GEN_VCD%"=="1" (
    echo Generating VCD for Surfer...
    echo open_vcd dump.vcd > sim_run.tcl
    echo log_vcd [get_objects -r *] >> sim_run.tcl
    echo run all >> sim_run.tcl
    echo close_vcd >> sim_run.tcl
    echo exit >> sim_run.tcl
) else (
    echo Generating WDB for Vivado...
    echo log_wave -recursive *; run all; exit > sim_run.tcl
)

call xsim my_snapshot -tclbatch sim_run.tcl

echo --- Simulation Complete ---
echo Check %OUT_DIR_NAME% for logs and waveform files.
exit /b 0

:: ---------------------------------------------------------
:: Subroutine: create_list
:: Scans the design and verification folders to build the list
:: ---------------------------------------------------------
:create_list
echo Scanning RTL and VERIF folders for sources...
type nul > "%FILE_LIST%" 
if exist "%RTL_DIR%" (
    dir /b /s "%RTL_DIR%\*.v" "%RTL_DIR%\*.sv" >> "%FILE_LIST%" 2>nul
)
if exist "%VERIF_DIR%" (
    dir /b /s "%VERIF_DIR%\*.v" "%VERIF_DIR%\*.sv" >> "%FILE_LIST%" 2>nul
)
echo Updated %FILE_LIST%
exit /b 0