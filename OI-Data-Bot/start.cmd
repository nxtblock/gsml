@echo off

if exist "./OI-Data-Bot-main/main.py" goto skip

echo Downloading OI-Data-Bot-main
powershell -Command "Start-BitsTransfer -Source 'https://j.1win.ggff.net/https://github.com/OI-liyifan202201/OI-Data-Bot/archive/refs/heads/main.zip' -Destination OI.zip"

echo Done
echo Unzipping
powershell -Command "Expand-Archive -Path OI.zip -DestinationPath ./"
echo Done

:skip

pip install ttkbootstrap -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install openai -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install openai -i https://pypi.tuna.tsinghua.edu.cn/simple

start python ./OI-Data-Bot-main/main.py

exit
