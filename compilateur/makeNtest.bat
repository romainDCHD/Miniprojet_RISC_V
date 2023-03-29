@echo off

REM Compilation des exécutables
:start
wsl make
echo.

REM Exécution des tests
cd tests\integration
wsl ./execute_tests.py runtest ../../bin/regexp-rematch.exe 00_test_regexp_basic
wsl ./execute_tests.py runtest ../../bin/regexp-read.exe 01_test_regexp_parse
wsl ./execute_tests.py runtest ../../bin/regexp-rematch.exe 02_test_regexp_match
wsl ./execute_tests.py runtest ../../bin/lexer.exe 03_test_lexer

REM Affichage des dossiers de résultats
echo.
explorer 00_test_regexp_basic_result
explorer 01_test_regexp_parse_result
explorer 02_test_regexp_match_result
explorer 03_test_lexer_result
pause
cd..
cd..
goto start
