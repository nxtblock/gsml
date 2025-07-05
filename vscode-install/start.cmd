@echo off
cls
title VSCode C++ 自动配置工具
color 0B
mode con: cols=80 lines=25

echo.
echo  [信息] VSCode C++ 自动配置脚本
echo  [开发者] liyifan202201
echo  ----------------------------------
echo.

:: 创建工作目录（如果不存在）
if not exist "C:\VSc-cpp\" (
    echo  [操作] 正在创建工作目录...
    md "C:\VSc-cpp" >nul 2>nul
    echo  [成功] 目录创建完成: C:\VSc-cpp
    echo.
)

:: VSCode 安装部分
if exist "C:\VSc-cpp\install-ok.txt" goto ainstall

echo  [操作] 正在下载 Visual Studio Code...
echo  请稍候，这可能需要一些时间...
echo.

:download_vscode
powershell -Command "Invoke-WebRequest -Uri 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user' -OutFile 'VSC.exe'"
if %errorlevel% neq 0 (
    echo  [错误] VSCode 下载失败，正在重试...
    goto download_vscode
)

echo  [成功] VSCode 下载完成!
echo  [操作] 正在静默安装 VSCode...
echo  安装过程中请不要关闭窗口...
echo.

start /wait VSC.exe /VERYSILENT /SP- /NORESTART /CLOSEAPPLICATIONS
del VSC.exe >nul 2>nul
taskkill /f /im code.exe >nul 2>nul

echo  [成功] VSCode 安装完成!
echo IAKIOI > "C:\VSc-cpp\install-ok.txt"
echo.

:ainstall

:: MinGW 安装部分
if exist "C:\VSc-cpp\insMinGW-ok.txt" goto binstall

echo  [操作] 正在下载 MinGW64...
echo  请稍候，这可能需要一些时间...
echo.

:download_mingw
powershell -Command "Invoke-WebRequest -Uri 'https://ghfile.geekertao.top/https://github.com/Github-liyifan202201/Github-liyifan202201/releases/download/v1.0/MinGW-64.zip' -OutFile 'MinGW.zip'"
if %errorlevel% neq 0 (
    echo  [错误] MinGW 下载失败，正在重试...
    goto download_mingw
)

echo  [成功] MinGW 下载完成!
echo  [操作] 正在解压 MinGW...
echo.

powershell -Command "Expand-Archive -Path 'MinGW.zip' -DestinationPath 'C:\VSc-cpp\MinGW\' -Force"
echo IAKIOI > "C:\VSc-cpp\insMinGW-ok.txt"
del MinGW.zip >nul 2>nul

echo  [成功] MinGW 安装完成!
echo  [操作] 正在更新环境变量...
echo.

setx PATH "%PATH%;C:\VSc-cpp\MinGW\bin;%appdata%\..\Local\Programs\Microsoft VS Code\bin" >nul
echo  [成功] 环境变量更新完成!
echo.

:: 安装扩展
:binstall
echo  [操作] 正在安装 VSCode 扩展...
echo  这可能需要几分钟，请耐心等待...
echo.

set "code_bin=%appdata%\..\Local\Programs\Microsoft VS Code\bin\code"

echo  [扩展] 正在安装: 中文语言包
start /wait /b powershell %code_bin% --install-extension MS-CEINTL.vscode-language-pack-zh-hans >nul 2>nul
echo { "locale": "zh-cn", "enable-crash-reporter": false} > "%USERPROFILE%\.vscode\argv.json"

echo  [扩展] 正在安装: C++ 工具包
start /wait /b powershell %code_bin% --install-extension ms-vscode.cpptools-extension-pack >nul 2>nul
start /wait /b powershell %code_bin% --install-extension ms-vscode.cpptools >nul 2>nul

echo  [扩展] 正在安装: 洛谷助手
start /wait /b powershell %code_bin% --install-extension yltx.vscode-luogu >nul 2>nul

echo  [扩展] 正在安装: 竞赛编程助手
start /wait /b powershell %code_bin% --install-extension DivyanshuAgrawal.competitive-programming-helper >nul 2>nul

echo  [扩展] 正在安装: CodeGeeX 智能编程
start /wait /b powershell %code_bin% --install-extension aminer.codegeex >nul 2>nul

echo  [扩展] 正在安装: 错误透镜
start /wait /b powershell %code_bin% --install-extension usernamehw.errorlens >nul 2>nul

echo.
echo  [成功] 所有扩展安装完成!
echo.

:: 启动 VSCode
echo  [操作] 正在启动 VSCode...
echo  配置即将完成...
echo.

start "" "%appdata%\..\Local\Programs\Microsoft VS Code\code.exe"
ping -n 5 127.0.0.1 >nul

:: 显示完成通知
powershell -Command "[Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $notify = New-Object Windows.Forms.NotifyIcon; $notify.Icon = [Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path); $notify.Visible = $true; $notify.ShowBalloonTip(5000, '安装完成', 'VSCode C++ 开发环境已成功配置!', [Windows.Forms.ToolTipIcon]::Info)"

echo  ----------------------------------
echo  [完成] VSCode C++ 环境已成功配置!
echo  按任意键启动 VSCode...
pause >nul

start "" "%appdata%\..\Local\Programs\Microsoft VS Code\code.exe"
exit