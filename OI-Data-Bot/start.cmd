@echo off

chcp 65001

if exist "./OI-Data-Bot-main/main.pyw" goto skip

echo ========================================
echo 正在下载 OI-Data-Bot
echo ========================================

powershell -Command "Start-BitsTransfer -Source 'https://git.ppp.ac.cn/https  ://github.com/OI-liyifan202201/OI-Data-Bot/archive/refs/heads/main.zip' -Destination OI.zip"

echo 下载完成！
echo ========================================
echo 正在解压文件
echo ========================================

powershell -Command "Expand-Archive -Path OI.zip -DestinationPath ./"

echo 解压完成！

:skip

echo ========================================
echo 正在安装依赖包
echo ========================================
pip install ttkbootstrap -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install openai -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install openai -i https://pypi.tuna.tsinghua.edu.cn/simple

echo ========================================
echo 启动 OI-Data-Bot
echo ========================================
start pythonw ./OI-Data-Bot-main/main.pyw

exit


