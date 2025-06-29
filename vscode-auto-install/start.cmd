echo off

color e3

cls

echo VScode C++ 自动安装脚本

echo 本程序由 liyifan202201 开发，

echo ---

md C:\VSc-cpp>nul 2>nul

if exist C:\VSc-cpp\install-ok.txt goto ainstall

echo [Start] 正在下载 Vscode ...

:vs

powershell Invoke-WebRequest -Uri \"https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user\"  -OutFile VSC.exe

if %errorlevel%==1 (echo VScode下载失败，尝试重试 & goto vs)

echo [Success] OK

echo [Start] 正在安装 Vscode ...

echo [INFO] 不要急，在后台安装...

VSC.exe /VERYSILENT /SP-

del VSC.exe

taskkill /f /im code.exe>nul 2>nul

echo [Success] OK

echo IAKIOI >> C:\VSc-cpp\install-ok.txt

:ainstall

if exist C:\VSc-cpp\insMinGW-ok.txt goto binstall

echo [Start] 正在下载 MinGW64

:mg

powershell Invoke-WebRequest -Uri \"https://ghfile.geekertao.top/https://github.com/Github-liyifan202201/Github-liyifan202201/releases/download/v1.0/MinGW-64.zip\"  -OutFile MinGW.zip

if %errorlevel%==1 (echo MinGW下载失败，尝试重试 & goto mg)

echo [Success] OK

echo [Start] 正在解压 MinGW64

powershell Expand-Archive -Path MinGW.zip -DestinationPath C:\VSc-cpp\MinGW\

echo IAKIOI >> C:\VSc-cpp\insMinGW-ok.txt

echo [Success] OK

del MinGW.zip>nul 2>nul



echo [Start] 正在设置 path

for /f "tokens=2,*" %%A in ('reg query HKCU\Environment /v PATH 2^>nul') do set my_user_path=%%B

setx path "%my_user_path%;C:\VSc-cpp\MinGW\bin;%appdata%\..\Local\Programs\Microsoft VS Code\bin"


goto main

:: Set one environment variable from registry key
:SetFromReg
    "%WinDir%\System32\Reg" QUERY "%~1" /v "%~2" > "%TEMP%\_envset.tmp" 2>NUL
    for /f "usebackq skip=2 tokens=2,*" %%A IN ("%TEMP%\_envset.tmp") do (
        echo/set "%~3=%%B"
    )
    goto :EOF

:: Get a list of environment variables from registry
:GetRegEnv
    "%WinDir%\System32\Reg" QUERY "%~1" > "%TEMP%\_envget.tmp"
    for /f "usebackq skip=2" %%A IN ("%TEMP%\_envget.tmp") do (
        if /I not "%%~A"=="Path" (
            call :SetFromReg "%~1" "%%~A" "%%~A"
        )
    )
    goto :EOF

:main
    echo/@echo off >"%TEMP%\_env.cmd"

    :: Slowly generating final file
    call :GetRegEnv "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" >> "%TEMP%\_env.cmd"
    call :GetRegEnv "HKCU\Environment">>"%TEMP%\_env.cmd" >> "%TEMP%\_env.cmd"

    :: Special handling for PATH - mix both User and System
    call :SetFromReg "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" Path Path_HKLM >> "%TEMP%\_env.cmd"
    call :SetFromReg "HKCU\Environment" Path Path_HKCU >> "%TEMP%\_env.cmd"

    :: Caution: do not insert space-chars before >> redirection sign
    echo/set "Path=%%Path_HKLM%%;%%Path_HKCU%%" >> "%TEMP%\_env.cmd"

    :: Cleanup
    del /f /q "%TEMP%\_envset.tmp" 2>nul
    del /f /q "%TEMP%\_envget.tmp" 2>nul

    :: capture user / architecture
    SET "OriginalUserName=%USERNAME%"
    SET "OriginalArchitecture=%PROCESSOR_ARCHITECTURE%"

    :: Set these variables
    call "%TEMP%\_env.cmd"

    :: Cleanup
    del /f /q "%TEMP%\_env.cmd" 2>nul

    :: reset user / architecture
    SET "USERNAME=%OriginalUserName%"
    SET "PROCESSOR_ARCHITECTURE=%OriginalArchitecture%"


:binstall

echo [Start] 正在设置插件
echo [INFO] 正在安装VScode插件：汉化
start /wait /b powershell code --install-extension MS-CEINTL.vscode-language-pack-zh-hans>nul 2>nul

echo { "locale": "zh-cn", "enable-crash-reporter": false} > %USERPROFILE%\.vscode\argv.json

echo [INFO] 正在安装VScode插件：C++
start /wait /b powershell code --install-extension ms-vscode.cpptools-extension-pack>nul 2>nul
start /wait /b powershell code --install-extension ms-vscode.cpptools>nul 2>nul
echo [INFO] 正在安装VScode插件：洛谷
start /wait /b powershell code --install-extension yltx.vscode-luogu>nul 2>nul
echo [INFO] 正在安装VScode插件：cph
start /wait /b powershell code --install-extension DivyanshuAgrawal.competitive-programming-helper>nul 2>nul
echo [INFO] 正在安装VScode插件：codegeex
start/wait  /b powershell code --install-extension aminer.codegeex>nul 2>nul
echo [INFO] 正在安装VScode插件：errorlens
start /wait /b powershell code --install-extension usernamehw.errorlens>nul 2>nul

explorer "%appdata%\..\Local\Programs\Microsoft VS Code\code.exe"
ping -n 10 127.0.0.1>nul
taskkill /f /im code.exe>nul 2>nul

powershell "[system.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null;$balloon = New-Object System.Windows.Forms.NotifyIcon;$path = Get-Process -id $pid | Select-Object -ExpandProperty Path;$icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path);$balloon.Icon = $icon;$balloon.BalloonTipIcon = 'Info';$balloon.BalloonTipText = '安装完毕';$balloon.BalloonTipTitle = 'VScode 自动配置脚本';$balloon.Visible = $true;$balloon.ShowBalloonTip(1)"

explorer "%appdata%\..\Local\Programs\Microsoft VS Code\code.exe"
