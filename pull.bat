@echo off
:pull
echo [93m
choice /c PC /m "Voulez vous [P]ull toutes les modifications ou [C]ancel ?"
if ERRORLEVEL 2 (
	exit
)
echo [0m
wsl git pull
echo.
if ERRORLEVEL 1 (
	echo [41mUne erreur est survenue, veuillez réessayer[0m
	goto pull
)
pause
exit