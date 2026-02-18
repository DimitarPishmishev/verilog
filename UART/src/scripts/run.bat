@echo off
REM --- CONFIG ---
set ROOT_DIR=%~dp0..\..
set OUT_DIR=%ROOT_DIR%\out

REM CHANGE THIS NAME when you create new testbenches!
set TOP_MODULE=tb_and_gate

REM --- CLEANUP ---
if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

REM --- EXECUTION ---
pushd "%OUT_DIR%"

echo [1/3] Compiling files from filelist.f...
REM -f tells Vivado to read the list of files from the text file
call xvlog -sv -f "%ROOT_DIR%\files_tb.f" > compile.log

echo [2/3] Elaborating %TOP_MODULE%...
call xelab -top %TOP_MODULE% -snapshot my_sim -debug typical > elaborate.log

echo [3/3] Simulating...
call xsim my_sim -R > simulate.log

popd
echo Done! Logs are in 'out/'.