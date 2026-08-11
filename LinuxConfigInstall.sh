#!/bin/bash
# ============================================================
# LinuxConfigInstall.sh - 「start githubdeploy」コマンドをセットアップします。
# 一度だけ実行してください。以後どのフォルダでも
# ターミナルで「start githubdeploy」と打てば使えるようになります。
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"
PROFILE="$HOME/.bashrc"

echo "=========================================="
echo "  start githubdeploy コマンドをセットアップ中... (Linux)"
echo "=========================================="

mkdir -p "$INSTALL_DIR"
cp "$SCRIPT_DIR/LinuxGithubDeploy.sh" "$INSTALL_DIR/LinuxGithubDeploy.sh"
chmod +x "$INSTALL_DIR/LinuxGithubDeploy.sh"

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
