chcp 65001 

@echo off

echo 按任意键启用透明窗口，启用后，按下 ctrl+shift+1~ctrl+shift+9 切换透明强度

if exist "./Vitrite/Vitrite-in-GSML-main/Vitrite.exe" goto skip

echo 下载中
powershell -Command "Start-BitsTransfer -Source 'https://j.1win.ggff.net/https://github.com/OI-liyifan202201/Vitrite-in-GSML/archive/refs/heads/main.zip' -Destination Vitrite.zip"

echo 完成
echo 解压中
powershell -Command "Expand-Archive -Path Vitrite.zip -DestinationPath ./Vitrite"
echo 完成

:skip

start "" "./Vitrite/Vitrite-in-GSML-main/Vitrite.exe"

echo 此透明窗口程序已在后台静默运行，按下 ctrl+shift+1~ctrl+shift+9 即可切换顶层窗口透明强度

pause

exit
