@echo off
setlocal enabledelayedexpansion

set gcc_args=-Wall -Wextra -g

set prog[0].nam=test_process_char_group
set prog[0].dep=src/char_group.c src/string.c src/list.c src/unitest.c
set prog[0].dir=tests/unit/
set prog[0].arg=-v

set prog[1].nam=test-regexp
set prog[1].dep=src/string.c src/list.c src/char_group.c src/regexp.c src/unitest.c
set prog[1].dir=tests/unit/
set prog[1].arg=-v

set prog[2].nam=regexp-rematch
set prog[2].dep=src/string.c src/list.c src/char_group.c src/regexp.c src/unitest.c
set prog[2].dir=prog/
set prog[2].arg=aa aabbbccccddddd

set prog[3].nam=regexp-read
set prog[3].dep=src/string.c src/list.c src/char_group.c src/regexp.c
set prog[3].dir=prog/
set prog[3].arg=[0-9]a*b*c*

set prog[4].nam=test_lexem
set prog[4].dep=src/string.c src/list.c src/char_group.c src/regexp.c src/unitest.c src/lexem.c
set prog[4].dir=tests/unit/
set prog[4].arg=-v

set prog[5].nam=lexer
set prog[5].dep=src/string.c src/list.c src/char_group.c src/regexp.c src/unitest.c src/lexem.c
set prog[5].dir=prog/
set prog[5].arg=database_pys.txt source.pys -v

set prog[6].nam=parser
set prog[6].dep=src/string.c src/list.c src/char_group.c src/regexp.c src/unitest.c src/lexem.c src/parser.c src/pyobj.c
set prog[6].dir=prog/
set prog[6].arg=source.pys database_pys.txt -v

set prog[7].nam=parser
set prog[7].dep=src/string.c src/list.c src/char_group.c src/regexp.c src/unitest.c src/lexem.c src/parser.c src/pyobj.c
set prog[7].dir=prog/
set prog[7].arg=source2.pys database_pys.txt -v


:start
cls
for /l %%i in (6,1,7) do call :display "!prog[%%i].nam!" "!prog[%%i].dep!" "!prog[%%i].dir!" "!prog[%%i].arg!"
pause
goto start

:display [nam] [dep] [dir] [arg]
	echo [94m========== Compilation de %~1.exe ==========[0m
	wsl gcc %gcc_args% %~2 %~3%~1.c -o ./bin/%~1.exe
	if NOT ERRORLEVEL 1 (
		echo.
		echo [94m---------- Execution de %~1.exe ----------[0m
		wsl valgrind --leak-check=full --show-leak-kinds=all ./bin/%~1.exe %~4
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