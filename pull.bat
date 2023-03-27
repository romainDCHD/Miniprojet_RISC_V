@echo off
echo [93m
choice /c PC /m "Voulez vous [P]ull toutes les modifications ou [C]ancel ?"
if ERRORLEVEL 2 (
	exit
)
echo [0m
wsl git pull
echo.
pause