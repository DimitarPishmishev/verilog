@echo off
REM --- CONFIG ---
set ROOT_DIR=%~dp0..\..
set OUT_DIR=%ROOT_DIR%\out
set SNAPSHOT=my_sim

REM --- EXECUTION ---
if not exist "%OUT_DIR%" (
    echo [ERROR] Output directory not found! Run the build script first.
    pause
    exit /b
)

pushd "%OUT_DIR%"

echo Opening Vivado Simulation GUI...
REM -gui tells Vivado to open the graphical window
REM -wdb tells it where to save the waveform database (optional but good practice)
call xsim %SNAPSHOT% -gui -wdb simulate_xsim.wdb

popd