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

REM 末尾の / を削除
if "%REPO_URL:~-1%"=="/" set "REPO_URL=%REPO_URL:~0,-1%"

REM 末尾が .git でなければ付け足す
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
