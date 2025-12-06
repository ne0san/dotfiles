# dotfiles
dotfiles fot my mac

## TODO / 手動設定が必要な項目

### Google日本語入力のライブ変換をオフ
現状、自動化する方法が不明のため、手動で以下の設定を行う：
1. Google日本語入力の設定を開く
2. 「入力補助」タブで「ライブ変換」のチェックを外す

これによりWindowsのIMEのようにスペースキーを押して初めて変換されるようになる。

### デフォルトブラウザをArcに設定
以下のコマンドで設定できるが、確認ダイアログが表示されるため完全自動化は不可：
```bash
brew install defaultbrowser  # 未インストールの場合
defaultbrowser arc
```
または、Arc.app > Set as Default Browser を手動で選択
