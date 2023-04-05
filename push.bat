@echo off
chcp 65001
cls

echo [94m----- Mise à jours du répo local -----[0m
:pull
echo [93m
choice /c PC /m "Voulez vous [P]ull toutes les modifications ou [C]ancel ?"
if ERRORLEVEL 2 (
	exit
)
echo [0m
wsl git pull
if ERRORLEVEL 1 (
	echo.
	echo [41mUne erreur est survenue, veuillez réessayer[0m
	goto pull
)
echo.

echo [94m----- Push des modifications -----[0m
:push
wsl git status
echo [93m
choice /c PC /m "Voulez vous [P]ush toutes les modifications ci-dessus ou [C]ancel ?"
if ERRORLEVEL 2 (
	exit
)
set /p "message=Entrez le message du commit : "
echo [0m
wsl git add -A
wsl git commit -m "%message%"
wsl git push
if ERRORLEVEL 1 (
	git reset HEAD~1
	echo.
	echo [41mUne erreur est survenue, veuillez réessayer[0m
	echo.
	goto push
)
wsl git status
echo.
pause
exit
