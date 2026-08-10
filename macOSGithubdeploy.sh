#!/bin/bash
# ============================================================
# githubdeploy - 汎用 GitHub Pages デプロイ処理
# 「start githubdeploy」コマンドから呼び出されます。
# 実行時のカレントディレクトリ(今いるプロジェクトフォルダ)に対して動作します。
# ============================================================

set -e

echo "=========================================="
echo "  GitHub Pages デプロイ"
echo "  フォルダ: $(pwd)"
echo "=========================================="
echo ""

if [ ! -f "package.json" ]; then
  echo "❌ package.json が見つかりません。プロジェクトフォルダの中で実行してください。"
  return 1 2>/dev/null || exit 1
fi

echo "GitHubのリポジトリURLを入力してください"
echo "例: https://github.com/kanorastudio/Cyber-Factory"
echo "(末尾の / や .git は付けても付けなくてもOK、自動で調整します)"
read -p "URL: " REPO_URL_INPUT

if [ -z "$REPO_URL_INPUT" ]; then
  echo "❌ URLが入力されませんでした。中止します。"
  return 1 2>/dev/null || exit 1
fi

REPO_URL="${REPO_URL_INPUT%/}"
if [[ "$REPO_URL" != *.git ]]; then
  REPO_URL="${REPO_URL}.git"
fi

echo ""
echo "→ 公開先: $REPO_URL"
echo ""

echo "[1/3] 依存パッケージを確認中..."
npm install

echo ""
echo "[2/3] ビルド中..."
npm run build

echo ""
echo "[3/3] GitHub Pages に公開中..."
npx gh-pages -d dist -r "$REPO_URL"

echo ""
echo "=========================================="
echo "  ✅ デプロイ完了！"
echo "  数分後に反映されます。"
echo "=========================================="
