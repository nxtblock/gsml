@echo off
cls

echo [INFO] VSCode C++ Auto Setup Script
echo Developed by liyifan202201
echo ----------------------------------

:: Create working directory if not exists
md C:\VSc-cpp >nul 2>nul

:: VSCode installation
if exist C:\VSc-cpp\install-ok.txt goto ainstall

echo [START] Downloading Visual Studio Code...

:download_vscode
powershell -Command "Invoke-WebRequest -Uri 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user' -OutFile 'VSC.exe'"
if %errorlevel%==1 (
    echo [ERROR] VSCode download failed. Retrying...
    goto download_vscode
)

echo [OK] Downloaded VSCode.
echo [START] Installing VSCode silently...

start /wait VSC.exe /VERYSILENT /SP-
del VSC.exe
taskkill /f /im code.exe >nul 2>nul

echo [OK] VSCode installed successfully.
echo IAKIOI >> C:\VSc-cpp\install-ok.txt

:ainstall

:: MinGW installation
if exist C:\VSc-cpp\insMinGW-ok.txt goto binstall

echo [START] Downloading MinGW64...

:download_mingw
powershell -Command "Invoke-WebRequest -Uri 'https://github.akams.cn/https://github.com/Github-liyifan202201/Github-liyifan202201/releases/download/v1.0/MinGW-64.zip' -OutFile 'MinGW.zip'"
if %errorlevel%==1 (
    echo [ERROR] MinGW download failed. Retrying...
    goto download_mingw
)

echo [OK] Downloaded MinGW.
echo [START] Extracting MinGW...
powershell -Command "Expand-Archive -Path 'MinGW.zip' -DestinationPath 'C:\VSc-cpp\MinGW\'"
echo [OK] Extracted MinGW.
echo IAKIOI >> C:\VSc-cpp\insMinGW-ok.txt
del MinGW.zip >nul 2>nul

:: Set PATH
echo [INFO] Updating environment variables...

for /f "tokens=2,*" %%A in ('reg query HKCU\Environment /v PATH 2^>nul') do set my_user_path=%%B
setx path "%my_user_path%;C:\VSc-cpp\MinGW\bin;%appdata%\..\Local\Programs\Microsoft VS Code\bin"

goto main

:: Environment preparation
:SetFromReg
    "%WinDir%\System32\Reg" QUERY "%~1" /v "%~2" > "%TEMP%\_envset.tmp" 2>NUL
    for /f "usebackq skip=2 tokens=2,*" %%A IN ("%TEMP%\_envset.tmp") do (
        echo/set "%~3=%%B"
    )
    goto :EOF

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
    call :GetRegEnv "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" >> "%TEMP%\_env.cmd"
    call :GetRegEnv "HKCU\Environment" >> "%TEMP%\_env.cmd"
    call :SetFromReg "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" Path Path_HKLM >> "%TEMP%\_env.cmd"
    call :SetFromReg "HKCU\Environment" Path Path_HKCU >> "%TEMP%\_env.cmd"
    echo/set "Path=%%Path_HKLM%%;%%Path_HKCU%%" >> "%TEMP%\_env.cmd"
    del /f /q "%TEMP%\_envset.tmp" 2>nul
    del /f /q "%TEMP%\_envget.tmp" 2>nul
    set "OriginalUserName=%USERNAME%"
    set "OriginalArchitecture=%PROCESSOR_ARCHITECTURE%"
    call "%TEMP%\_env.cmd"
    del /f /q "%TEMP%\_env.cmd" 2>nul
    set "USERNAME=%OriginalUserName%"
    set "PROCESSOR_ARCHITECTURE=%OriginalArchitecture%"

:: Install extensions
:binstall
echo [START] Installing VSCode extensions...

set code_bin="%appdata%\..\Local\Programs\Microsoft VS Code\bin\code"

echo [EXT] Installing: Chinese Language Pack
start /wait /b powershell code --install-extension MS-CEINTL.vscode-language-pack-zh-hans >nul 2>nul
echo { "locale": "zh-cn", "enable-crash-reporter": false} > %USERPROFILE%\.vscode\argv.json

echo [EXT] Installing: C++ Pack
start /wait /b powershell code --install-extension ms-vscode.cpptools-extension-pack >nul 2>nul
start /wait /b powershell code --install-extension ms-vscode.cpptools >nul 2>nul

echo [EXT] Installing: Luogu Helper
start /wait /b powershell code --install-extension yltx.vscode-luogu >nul 2>nul

echo [EXT] Installing: Competitive Programming Helper
start /wait /b powershell code --install-extension DivyanshuAgrawal.competitive-programming-helper >nul 2>nul

echo [EXT] Installing: CodeGeeX
start /wait /b powershell code --install-extension aminer.codegeex >nul 2>nul

echo [EXT] Installing: Error Lens
start /wait /b powershell code --install-extension usernamehw.errorlens >nul 2>nul

:: Final launch
explorer "%appdata%\..\Local\Programs\Microsoft VS Code\code.exe"
ping -n 10 127.0.0.1 >nul
taskkill /f /im code.exe >nul 2>nul
powershell "[system.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null;$balloon = New-Object System.Windows.Forms.NotifyIcon;$path = Get-Process -id $pid | Select-Object -ExpandProperty Path;$icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path);$balloon.Icon = $icon;$balloon.BalloonTipIcon = 'Info';$balloon.BalloonTipText = 'You can use your vscode.';$balloon.BalloonTipTitle = 'VScode-install in gsml';$balloon.Visible = $true;$balloon.ShowBalloonTip(1)"
pause
exit

explorer "%appdata%\..\Local\Programs\Microsoft VS Code\code.exe"
