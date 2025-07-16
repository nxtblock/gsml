@echo off

if exist "./PCL2/Plain Craft Launcher.exe" goto skip

echo Downloading PCL2
powershell -Command "Start-BitsTransfer -Source 'https://git.ppp.ac.cn/https://raw.githubusercontent.com/OI-liyifan202201/nbsmc-PCL2-in-GSML/refs/heads/main/nbsmc.zip' -Destination nbsmc.zip"

echo Done
echo Unzipping
powershell -Command "Expand-Archive -Path nbsmc.zip -DestinationPath ./PCL2"
echo Done

:skip

start "" "./PCL2/Plain Craft Launcher.exe"


ping 127.0.0.1 -n 3 >nul
exit
