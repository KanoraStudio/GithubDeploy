# start githubdeploy

どのプロジェクトフォルダにいても `start githubdeploy` と打つだけで、
ビルド(`npm run build`)から GitHub Pages への公開(`gh-pages`)まで自動で行うコマンドラインツールです。

macOS / Windows / Linux に対応しています。

---

## 前提条件

- [Node.js](https://nodejs.org/)(`npm` コマンドが使えること)がインストール済みであること
- デプロイしたいプロジェクトの `package.json` に `dist` フォルダを生成するビルドスクリプト(`npm run build`)があること
- `gh-pages` パッケージがプロジェクトの `devDependencies` に入っていること(無い場合は `npm install --save-dev gh-pages` を実行)
- 対象のGitHubリポジトリへの push 権限があること

---

## セットアップ(最初の1回だけ)

お使いのOSに応じたファイルを1つダウンロードして実行してください。他のファイルは不要です。

### macOS

1. `MacOSConfigInstall.sh` をダウンロード
2. ターミナルでダウンロードしたフォルダに移動し、実行:
   ```bash
   chmod +x MacOSConfigInstall.sh
   ./MacOSConfigInstall.sh
   ```
3. 案内に従って以下を実行(またはターミナルを開き直す):
   ```bash
   source ~/.zshrc
   ```

### Windows

1. `WindowsConfigInstall.bat` をダウンロード
2. ダブルクリックで実行(コマンドプロンプトが開いて自動でセットアップされます)
3. セットアップ完了後、開いているコマンドプロンプトを閉じて新しく開き直す

### Linux

1. `LinuxConfigInstall.sh` をダウンロード
2. ターミナルでダウンロードしたフォルダに移動し、実行:
   ```bash
   chmod +x LinuxConfigInstall.sh
   ./LinuxConfigInstall.sh
   ```
3. 案内に従って以下を実行(またはターミナルを開き直す):
   ```bash
   source ~/.bashrc
   ```
   ※ zshをお使いの場合は、表示された内容を `~/.zshrc` にも手動で追記してください。

---

## 使い方

セットアップ後は、公開したい**プロジェクトのフォルダ内**(`package.json` がある場所)でターミナル/コマンドプロンプトを開き、以下を実行するだけです。

```
start githubdeploy
```

実行すると、GitHubのリポジトリURLの入力を求められます。

```
URL: https://github.com/ユーザー名/リポジトリ名
```

- 末尾に `/` が付いていても自動で削除されます
- `.git` が付いていなくても自動で補完されます

その後は自動で以下が進みます。

1. `npm install`(依存パッケージの確認)
2. `npm run build`(ビルド)
3. `npx gh-pages -d dist -r <入力したURL>`(GitHub Pagesへ公開)

数分後、`https://ユーザー名.github.io/リポジトリ名/` に反映されます。

---

## 仕組み

`〜ConfigInstall` ファイルを実行すると、内部に埋め込まれた実処理スクリプト
(`MacOSGithubDeploy.sh` / `githubdeploy.bat` / `LinuxGithubDeploy.sh`)が
以下の場所に自動生成・配置されます。

| OS | 生成場所 |
|---|---|
| macOS | `~/.local/bin/MacOSGithubDeploy.sh` |
| Windows | `%USERPROFILE%\bin\githubdeploy.bat` |
| Linux | `~/.local/bin/LinuxGithubDeploy.sh` |

- **macOS / Linux**: シェルの設定ファイル(`~/.zshrc` または `~/.bashrc`)に `start` という関数を追加し、`start githubdeploy` と打つとその関数がスクリプトを呼び出す仕組みです。
- **Windows**: Windows標準の `start` コマンド(別ウィンドウでプログラムを起動する機能)がそのまま使われています。生成されたファイルを `githubdeploy.bat` という名前でPATHに登録することで、`start githubdeploy` と打つと自動でそれが起動する仕組みです。

---

## トラブルシューティング

**`start githubdeploy` と打っても反応しない**
→ セットアップ後にターミナル/コマンドプロンプトを開き直しましたか？ PATHやシェル設定の変更は新しいウィンドウでないと反映されません。

**`package.json が見つかりません` と出る**
→ プロジェクトのルートフォルダ(`package.json` がある場所)で実行しているか確認してください。

**`npm run build` の時点で失敗する**
→ プロジェクト側のビルドエラーです。表示されたログを確認してください。

**再セットアップしたい/やり直したい**
→ 同じ `〜ConfigInstall` をもう一度実行すれば上書きされます。何度実行しても安全です。

---

## アンインストール

### macOS / Linux
1. `~/.zshrc`(または `~/.bashrc`)内の以下のブロックを削除:
   ```
   # >>> start githubdeploy setup >>>
   ...
   # <<< start githubdeploy setup <<<
   ```
2. 生成されたスクリプトを削除:
   ```bash
   rm ~/.local/bin/MacOSGithubDeploy.sh   # または LinuxGithubDeploy.sh
   ```

### Windows
1. `%USERPROFILE%\bin\githubdeploy.bat` を削除
2. 環境変数PATHから `%USERPROFILE%\bin` を手動で削除(システムのプロパティ → 環境変数から編集)
