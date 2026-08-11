#!/bin/bash
# ============================================================
# LinuxConfigInstall.sh
# これ1つだけ実行すればOK。
# LinuxGithubDeploy.sh を自動生成し、
# 「start githubdeploy」コマンドをセットアップします。
# ============================================================

set -e

INSTALL_DIR="$HOME/.local/bin"
PROFILE="$HOME/.bashrc"
DEPLOY_SCRIPT="$INSTALL_DIR/LinuxGithubDeploy.sh"

echo "=========================================="
echo "  start githubdeploy コマンドをセットアップ中... (Linux)"
echo "=========================================="

mkdir -p "$INSTALL_DIR"

# --- LinuxGithubDeploy.sh をこのファイルの中身から生成 ---
cat > "$DEPLOY_SCRIPT" << 'DEPLOY_EOF'
#!/bin/bash
# LinuxGithubDeploy.sh - 汎用 GitHub Pages デプロイ処理
# 実行時のカレントディレクトリ(今いるプロジェクトフォルダ)に対して動作します。

set -e

echo "=========================================="
echo "  GitHub Pages デプロイ (Linux)"
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
DEPLOY_EOF

chmod +x "$DEPLOY_SCRIPT"
echo "✅ LinuxGithubDeploy.sh を生成しました: $DEPLOY_SCRIPT"

# --- ~/.bashrc に "start" 関数を追加(まだ無ければ) ---
if ! grep -q "# >>> start githubdeploy setup >>>" "$PROFILE" 2>/dev/null; then
  cat >> "$PROFILE" << 'EOF'

# >>> start githubdeploy setup >>>
start() {
  if [ "$1" = "githubdeploy" ]; then
    source "$HOME/.local/bin/LinuxGithubDeploy.sh"
  else
    echo "使い方: start githubdeploy"
  fi
}
# <<< start githubdeploy setup <<<
EOF
  echo "✅ ~/.bashrc に start コマンドを追加しました"
else
  echo "ℹ️  すでに設定済みでした（スキップ）"
fi

echo ""
echo "=========================================="
echo "  ✅ セットアップ完了！"
echo ""
echo "  一度ターミナルを閉じて開き直すか、"
echo "  以下を実行してから使ってください:"
echo "  source ~/.bashrc"
echo ""
echo "  その後はどのプロジェクトフォルダでも"
echo "  「start githubdeploy」と打てば使えます。"
echo ""
echo "  ※ zshをお使いの場合は ~/.zshrc に同じ内容を"
echo "     手動で追記してください。"
echo "=========================================="
