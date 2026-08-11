#!/bin/bash
# ============================================================
# MacOSConfigInstall.sh - 「start githubdeploy」コマンドをセットアップします。
# 一度だけ実行してください。以後どのフォルダでも
# ターミナルで「start githubdeploy」と打てば使えるようになります。
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"
PROFILE="$HOME/.zshrc"

echo "=========================================="
echo "  start githubdeploy コマンドをセットアップ中... (macOS)"
echo "=========================================="

mkdir -p "$INSTALL_DIR"
cp "$SCRIPT_DIR/MacOSGithubDeploy.sh" "$INSTALL_DIR/MacOSGithubDeploy.sh"
chmod +x "$INSTALL_DIR/MacOSGithubDeploy.sh"

if ! grep -q "# >>> start githubdeploy setup >>>" "$PROFILE" 2>/dev/null; then
  cat >> "$PROFILE" << 'EOF'

# >>> start githubdeploy setup >>>
start() {
  if [ "$1" = "githubdeploy" ]; then
    source "$HOME/.local/bin/MacOSGithubDeploy.sh"
  else
    echo "使い方: start githubdeploy"
  fi
}
# <<< start githubdeploy setup <<<
EOF
  echo "✅ ~/.zshrc に start コマンドを追加しました"
else
  echo "ℹ️  すでに設定済みでした（スキップ）"
fi

echo ""
echo "=========================================="
echo "  ✅ セットアップ完了！"
echo ""
echo "  一度ターミナルを閉じて開き直すか、"
echo "  以下を実行してから使ってください:"
echo "  source ~/.zshrc"
echo ""
echo "  その後はどのプロジェクトフォルダでも"
echo "  「start githubdeploy」と打てば使えます。"
echo "=========================================="
