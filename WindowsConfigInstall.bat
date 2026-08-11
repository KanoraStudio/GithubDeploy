@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

echo ==========================================
echo   start githubdeploy コマンドをセットアップ中... (Windows)
echo ==========================================

set "INSTALL_DIR=%USERPROFILE%\bin"
set "SCRIPT_DIR=%~dp0"

REM 1. 専用フォルダを作成してコピー
REM    ※ Windowsの「start」コマンドはファイル名で探すため、
REM       ここではインストール先で "githubdeploy.bat" という名前に統一します。
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
copy /Y "%SCRIPT_DIR%WindowsGithubDeploy.bat" "%INSTALL_DIR%\githubdeploy.bat" >nul

REM 2. PATHに追加されているか確認、無ければユーザーPATHに追加
echo %PATH% | find /I "%INSTALL_DIR%" >nul
if errorlevel 1 (
    for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "CURRENT_PATH=%%B"
    if "!CURRENT_PATH!"=="" (
        setx PATH "%INSTALL_DIR%" >nul
    ) else (
        setx PATH "!CURRENT_PATH!;%INSTALL_DIR%" >nul
    )
    echo ✅ PATHに %INSTALL_DIR% を追加しました
) else (
    echo ℹ️  すでにPATHに登録済みでした（スキップ）
)

echo.
echo ==========================================
echo   ✅ セットアップ完了！
echo.
echo   一度コマンドプロンプトを閉じて開き直してください。
echo   その後はどのプロジェクトフォルダでも
echo   「start githubdeploy」と打てば使えます。
echo ==========================================
pause
