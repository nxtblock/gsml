

chcp 65001

title [GSML]

@echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit




echo 这是一个可以加速所有 Cloudflare 网站的脚本，比如说 Codeforces，Luogu 国际等等
if exist "./cfst/cfst_hosts.bat" goto skip
echo ======================================= 
echo 正在下载 CloudflareST 启动器

echo ======================================= 

powershell -Command "Start-BitsTransfer -Source 'http://hk1-proxy.gitwarp.com:8888/https://github.com/XIU2/CloudflareSpeedTest/releases/download/v2.3.4/cfst_windows_amd64.zip' -Destination cfst.zip"
echo 下载完成！
echo ========================================
echo 正在解压文件
echo ========================================
powershell -Command "Expand-Archive -Path cfst.zip -DestinationPath ./cfst/"
echo 解压完成！
:skip
echo ========================================
echo 启动 CFST 脚本
echo ========================================
echo .| "%~dp0\cfst\cfst_hosts.bat"


exit
