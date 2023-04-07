@echo off
setlocal enabledelayedexpansion

REM set gcc_args=-Wall -Wextra -g
set gcc_args=-Wall -Wextra -O3

set prog[0].nam=rv32icomp
set prog[0].dep=src\string.c src\list.c src\char_group.c src\regexp.c src\unitest.c src\lexem.c src\parser.c src\asm_line.c
set prog[0].dir=prog/
set prog[0].arg=test.asm database.txt  test.bin 

:start
cls
for /l %%i in (0,1,0) do call :display "!prog[%%i].nam!" "!prog[%%i].dep!" "!prog[%%i].dir!" "!prog[%%i].arg!"
pause
goto start

:display [nam] [dep] [dir] [arg]
	echo [94m========== Compilation de %~1.exe ==========[0m
	gcc %gcc_args% %~2 %~3%~1.c -o bin\%~1.exe
	if NOT ERRORLEVEL 1 (
		echo.
		echo [94m---------- Execution de %~1.exe ----------[0m
		bin\%~1.exe %~4
		call :print_errlevel "%errorlevel%"
		echo.
	) else (
		echo.
		echo [41mErreur de compilation, veuillez voir le message GCC plus haut[0m
	)
	echo.
	goto :eof

:print_errlevel [errlevel]
	echo.
	echo [96mValeur de retour [97m%~1[0m
	goto :eof