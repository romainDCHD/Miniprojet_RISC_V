@echo off
chcp 65001
setlocal enabledelayedexpansion

REM set PROJECT_PATH=C:/Users/Gael/Documents/Phelma/Miniprojet_RISC_V/
set PROJECT_PATH=D:/Dossier principal/Documents/Phelma/Miniprojet_RISC_V
set WINCONFIG_PATH=winconfig
set RTL_PATH=rtl
set BENCH_PATH=bench
set LIB_PATH=libs/libMiniproj_RISCV
set LIB_NAME=LIB_Miniproj_RISCV
set COMP_ARGS=-reportprogress 300 -work

set RTL_FILE[0]=control_logic.sv

set BENCH_FILE[0]=bench_control_logic.sv

:start
cls

cd %PROJECT_PATH%/%WINCONFIG_PATH%

echo [94m========== Recréation de %LIB_NAME% ==========[0m

vdel -lib  "%PROJECT_PATH%/%LIB_PATH%" -all
vlib "%PROJECT_PATH%/%LIB_PATH%"
vmap -modelsimini "%PROJECT_PATH%/%WINCONFIG_PATH%/modelsim.ini" %LIB_NAME% "%PROJECT_PATH%/%LIB_PATH%"
vmap %LIB_NAME%

if ERRORLEVEL 1 (
	echo.
	echo [41mErreur lors de la recréation de la librairie[0m
	goto end
)

echo.

for /l %%i in (0,1,0) do call :display "!RTL_FILE[%%i]!"  %RTL_PATH%
for /l %%i in (0,1,0) do call :display "!BENCH_FILE[%%i]!" %BENCH_PATH%

echo [94m========== Exécution de ModelSim ==========[0m
vsim

goto end

:display [nam] [dir]
	echo [94m========== Compilation de %~1.exe ==========[0m
	vlog %COMP_ARGS% %LIB_NAME% "%PROJECT_PATH%/%~2/%~1"
	
	if ERRORLEVEL 1 (
		echo.
		echo [41mErreur de compilation, veuillez voir le message vlog plus haut[0m
		goto end
	)
	
	echo.
	goto :eof

:end
pause
goto start