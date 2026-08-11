@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

echo ==========================================
echo   start githubdeploy コマンドをセットアップ中... (Windows)
echo ==========================================

set "INSTALL_DIR=%USERPROFILE%\bin"
set "TARGET=%INSTALL_DIR%\githubdeploy.bat"

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

REM --- このファイル自身の末尾に埋め込まれた内容を githubdeploy.bat として書き出す ---
REM     (Windowsの start コマンドがファイル名で探すため、ここでは
REM      インストール先を "githubdeploy.bat" という名前に統一します)
for /f "tokens=1 delims=:" %%A in ('findstr /n "^REM PAYLOAD_MARKER" "%~f0"') do set "ML=%%A"
set /a ML=%ML%+1
more +%ML% "%~f0" > "%TARGET%"

echo ✅ githubdeploy.bat を生成しました: %TARGET%

REM --- PATHに追加されているか確認、無ければユーザーPATHに追加 ---
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
exit /b 0

REM PAYLOAD_MARKER
@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

echo ==========================================
echo   GitHub Pages デプロイ (Windows)
echo   フォルダ: %CD%
echo ==========================================
echo.

if not exist "package.json" (
    echo [エラー] package.json が見つかりません。プロジェクトフォルダの中で実行してください。
    pause
    exit /b 1
)

echo GitHubのリポジトリURLを入力してください
echo 例: https://github.com/kanorastudio/Cyber-Factory
echo (末尾の / や .git は付けても付けなくてもOK、自動で調整します)
set /p REPO_URL_INPUT="URL: "

if "%REPO_URL_INPUT%"=="" (
    echo [エラー] URLが入力されませんでした。中止します。
    pause
    exit /b 1
)

set "REPO_URL=%REPO_URL_INPUT%"

if "%REPO_URL:~-1%"=="/" set "REPO_URL=%REPO_URL:~0,-1%"
if /I not "%REPO_URL:~-4%"==".git" set "REPO_URL=%REPO_URL%.git"

echo.
echo → 公開先: %REPO_URL%
echo.

echo [1/3] 依存パッケージを確認中...
call npm install
if errorlevel 1 goto :error

echo.
echo [2/3] ビルド中...
call npm run build
if errorlevel 1 goto :error

echo.
echo [3/3] GitHub Pages に公開中...
call npx gh-pages -d dist -r "%REPO_URL%"
if errorlevel 1 goto :error

echo.
echo ==========================================
echo   ✅ デプロイ完了！
echo   数分後に反映されます。
echo ==========================================
pause
exit /b 0

:error
echo.
echo ==========================================
echo   ❌ エラーが発生しました。上のログを確認してください。
echo ==========================================
pause
exit /b 1
