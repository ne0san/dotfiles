#!/bin/zsh

# macOS設定スクリプト
# 使用前に現在の設定をバックアップすることを推奨
# 実行前に必ずアプリケーションを終了してください

echo "🚀 macOSの設定を開始します..."

# 現在の設定をバックアップ
echo "📦 現在の設定をバックアップ中..."
mkdir -p ~/dotfiles_backup/$(date +%Y%m%d_%H%M%S)
defaults read > ~/dotfiles_backup/$(date +%Y%m%d_%H%M%S)/defaults_backup.txt

# スクリーンショット保存先をピクチャフォルダに設定
echo "📸 スクリーンショット保存先をピクチャフォルダに設定..."
defaults write com.apple.screencapture location ~/Pictures
killall SystemUIServer

# トラックパッド感度を7番目に設定 (0-3の範囲で、3が最も感度が高い)
echo "🖱️ トラックパッド感度を設定中..."
defaults write -g com.apple.trackpad.scaling 1.5

# Dock自動非表示を有効化
echo "🏠 Dock自動非表示を有効化..."
defaults write com.apple.dock autohide -bool true

# Dock「最近使用したアプリケーション」を無効化
echo "🗑️ Dockから最近使用したアプリケーションを削除..."
defaults write com.apple.dock show-recents -bool false

# Finder拡張子表示を有効化
echo "📁 Finder拡張子表示を有効化..."
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder隠しファイル表示を有効化
echo "👁️ Finder隠しファイル表示を有効化..."
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finderのデフォルト表示場所をホームディレクトリに設定
echo "🏡 Finderのデフォルト表示をホームディレクトリに設定..."
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Caps LockをControlキーに変更
echo "⌨️ Caps LockをControlキーに変更..."
# 外部キーボード用（製品IDは環境によって異なる場合があります）
defaults -currentHost write -g com.apple.keyboard.modifiermapping.0-0-0 -array-add '<dict><key>HIDKeyboardModifierMappingDst</key><integer>2</integer><key>HIDKeyboardModifierMappingSrc</key><integer>0</integer></dict>'

# キーボードリピート開始までの時間を短く設定 (15が最短)
echo "⚡ キーボードリピート設定を最高速に..."
defaults write NSGlobalDomain InitialKeyRepeat -int 30
# キーボードリピート速度を最高速に設定 (2が最高速)
defaults write NSGlobalDomain KeyRepeat -int 2

# ダークモードを有効化
echo "🌙 ダークモードを有効化..."
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Function キーを標準のF1、F2キーとして使用
echo "🔧 Function キーを標準のF1-F12キーとして設定..."
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Finderの表示をカラム表示に設定
echo "📊 Finderの表示をカラム表示に設定..."
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Fnキーの機能を無効化（何もしない）
echo "🚫 Fnキーの特別な機能を無効化..."
defaults write com.apple.HIToolbox AppleFnUsageType -int 0

# 起動音を無効化
echo "🔇 起動音を無効化..."
sudo nvram StartupMute=%01

# 最小化時ウィンドウをアプリアイコンに収納
echo "ウィンドウをDockのアプリアイコンに収納"
defaults write com.apple.dock minimize-to-application -bool true

# 変更を適用するためにアプリケーションを再起動
echo "🔄 設定を適用するためにアプリケーションを再起動中..."
killall Dock
killall Finder
killall SystemUIServer

echo ""
echo "✅ 設定完了！以下の変更が適用されました："
echo "   📸 スクリーンショット保存先: ~/Pictures"
echo "   🖱️ トラックパッド感度: 最高"
echo "   🏠 Dock: 自動非表示"
echo "   🗑️ Dock: 最近使用したアプリを非表示"
echo "   📁 Finder: 拡張子表示"
echo "   👁️ Finder: 隠しファイル表示"
echo "   🏡 Finder: ホームディレクトリ表示"
echo "   ⌨️ Caps Lock → Control"
echo "   ⚡ キーボードリピート: 最高速"
echo "   🌙 ダークモード: 有効"
echo "   🔧 Function キー: 標準F1-F12"
echo "   📊 Finder: カラム表示"
echo "   🚫 Fnキー: 特別機能無効"
echo "   🔇 起動音: 無効"
echo ""
echo "💡 一部の設定はログアウト/再ログインまたは再起動後に反映されます"
echo "🔄 変更を元に戻したい場合は ~/dotfiles_backup/ のファイルを参考にしてください"
