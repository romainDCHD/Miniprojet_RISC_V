@echo off
chcp 65001
setlocal enabledelayedexpansion

set PROJECT_PATH=C:/Users/Gael/Documents/Phelma/Miniprojet_RISC_V
REM set PROJECT_PATH=D:/Dossier principal/Documents/Phelma/Miniprojet_RISC_V
set WINCONFIG_PATH=winconfig
set RTL_PATH=rtl
set BENCH_PATH=bench
set LIB_PATH=libs/libMiniproj_RISCV
set LIB_NAME=LIB_Miniproj_RISCV
set COMP_ARGS=-reportprogress 300 -work

set RTL_FILE[0]=*.sv
REM set RTL_FILE[0]=3dff.sv
REM set RTL_FILE[1]=alu.sv
REM set RTL_FILE[2]=control_logic.sv
REM set RTL_FILE[3]=imem.sv
REM set RTL_FILE[4]=fetch_in.sv
REM set RTL_FILE[5]=imm_gen.sv
REM set RTL_FILE[6]=mem.sv
REM set RTL_FILE[7]=opti.sv
REM set RTL_FILE[8]=regfile.sv
REM set RTL_FILE[9]=wb.sv
REM set RTL_FILE[10]=branch_comp.sv
REM set RTL_FILE[11]=riscv.sv

set BENCH_FILE[0]=*.sv
REM set BENCH_FILE[0]=bench_control_logic.sv
REM set BENCH_FILE[1]=bench_regfile.sv
REM set BENCH_FILE[2]=test_branch_comp.sv
REM set BENCH_FILE[3]=test_fetch_imem.sv
REM set BENCH_FILE[4]=test_fetch_in.sv
REM set BENCH_FILE[5]=test_imm_gen.sv
REM set BENCH_FILE[6]=test_mem.sv
REM set BENCH_FILE[7]=test_opti.sv
REM set BENCH_FILE[8]=bench_riscv.sv

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
REM vsim
vsim -voptargs=+acc LIB_Miniproj_RISCV.bench_riscv

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