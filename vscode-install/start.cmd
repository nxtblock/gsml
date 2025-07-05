@echo off
cls
title VSCode C++ �Զ����ù���
color 0B
mode con: cols=80 lines=25

echo.
echo  [��Ϣ] VSCode C++ �Զ����ýű�
echo  [������] liyifan202201
echo  ----------------------------------
echo.

:: ��������Ŀ¼����������ڣ�
if not exist "C:\VSc-cpp\" (
    echo  [����] ���ڴ�������Ŀ¼...
    md "C:\VSc-cpp" >nul 2>nul
    echo  [�ɹ�] Ŀ¼�������: C:\VSc-cpp
    echo.
)

:: VSCode ��װ����
if exist "C:\VSc-cpp\install-ok.txt" goto ainstall

echo  [����] �������� Visual Studio Code...
echo  ���Ժ��������ҪһЩʱ��...
echo.

:download_vscode
powershell -Command "Invoke-WebRequest -Uri 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user' -OutFile 'VSC.exe'"
if %errorlevel% neq 0 (
    echo  [����] VSCode ����ʧ�ܣ���������...
    goto download_vscode
)

echo  [�ɹ�] VSCode �������!
echo  [����] ���ھ�Ĭ��װ VSCode...
echo  ��װ�������벻Ҫ�رմ���...
echo.

start /wait VSC.exe /VERYSILENT /SP- /NORESTART /CLOSEAPPLICATIONS
del VSC.exe >nul 2>nul
taskkill /f /im code.exe >nul 2>nul

echo  [�ɹ�] VSCode ��װ���!
echo IAKIOI > "C:\VSc-cpp\install-ok.txt"
echo.

:ainstall

:: MinGW ��װ����
if exist "C:\VSc-cpp\insMinGW-ok.txt" goto binstall

echo  [����] �������� MinGW64...
echo  ���Ժ��������ҪһЩʱ��...
echo.

:download_mingw
powershell -Command "Invoke-WebRequest -Uri 'https://ghfile.geekertao.top/https://github.com/Github-liyifan202201/Github-liyifan202201/releases/download/v1.0/MinGW-64.zip' -OutFile 'MinGW.zip'"
if %errorlevel% neq 0 (
    echo  [����] MinGW ����ʧ�ܣ���������...
    goto download_mingw
)

echo  [�ɹ�] MinGW �������!
echo  [����] ���ڽ�ѹ MinGW...
echo.

powershell -Command "Expand-Archive -Path 'MinGW.zip' -DestinationPath 'C:\VSc-cpp\MinGW\' -Force"
echo IAKIOI > "C:\VSc-cpp\insMinGW-ok.txt"
del MinGW.zip >nul 2>nul

echo  [�ɹ�] MinGW ��װ���!
echo  [����] ���ڸ��»�������...
echo.

setx PATH "%PATH%;C:\VSc-cpp\MinGW\bin;%appdata%\..\Local\Programs\Microsoft VS Code\bin" >nul
echo  [�ɹ�] ���������������!
echo.

:: ��װ��չ
:binstall
echo  [����] ���ڰ�װ VSCode ��չ...
echo  �������Ҫ�����ӣ������ĵȴ�...
echo.

set "code_bin=%appdata%\..\Local\Programs\Microsoft VS Code\bin\code"

echo  [��չ] ���ڰ�װ: �������԰�
start /wait /b powershell %code_bin% --install-extension MS-CEINTL.vscode-language-pack-zh-hans >nul 2>nul
echo { "locale": "zh-cn", "enable-crash-reporter": false} > "%USERPROFILE%\.vscode\argv.json"

echo  [��չ] ���ڰ�װ: C++ ���߰�
start /wait /b powershell %code_bin% --install-extension ms-vscode.cpptools-extension-pack >nul 2>nul
start /wait /b powershell %code_bin% --install-extension ms-vscode.cpptools >nul 2>nul

echo  [��չ] ���ڰ�װ: �������
start /wait /b powershell %code_bin% --install-extension yltx.vscode-luogu >nul 2>nul

echo  [��չ] ���ڰ�װ: �����������
start /wait /b powershell %code_bin% --install-extension DivyanshuAgrawal.competitive-programming-helper >nul 2>nul

echo  [��չ] ���ڰ�װ: CodeGeeX ���ܱ��
start /wait /b powershell %code_bin% --install-extension aminer.codegeex >nul 2>nul

echo  [��չ] ���ڰ�װ: ����͸��
start /wait /b powershell %code_bin% --install-extension usernamehw.errorlens >nul 2>nul

echo.
echo  [�ɹ�] ������չ��װ���!
echo.

:: ���� VSCode
echo  [����] �������� VSCode...
echo  ���ü������...
echo.

start "" "%appdata%\..\Local\Programs\Microsoft VS Code\code.exe"
ping -n 5 127.0.0.1 >nul

:: ��ʾ���֪ͨ
powershell -Command "[Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $notify = New-Object Windows.Forms.NotifyIcon; $notify.Icon = [Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path); $notify.Visible = $true; $notify.ShowBalloonTip(5000, '��װ���', 'VSCode C++ ���������ѳɹ�����!', [Windows.Forms.ToolTipIcon]::Info)"

echo  ----------------------------------
echo  [���] VSCode C++ �����ѳɹ�����!
echo  ����������� VSCode...
pause >nul

start "" "%appdata%\..\Local\Programs\Microsoft VS Code\code.exe"
exit