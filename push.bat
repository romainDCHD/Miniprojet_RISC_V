@echo off
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
wsl git status
echo.
pause
exit
