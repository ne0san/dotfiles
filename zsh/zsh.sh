#!/bin/zsh

# Install oh-my-zsh
echo ""
echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# インストール成否確認
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "✗ oh-my-zsh installation failed!"
    exit 1
fi

echo "✓ oh-my-zsh installed successfully"

# .zshrc.pre-oh-my-zshを復元
echo ""
echo "Restoring original .zshrc..."
if [ -f "$HOME/.zshrc.pre-oh-my-zsh" ]; then
    mv "$HOME/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc"
    echo "✓ Original .zshrc restored"
else
    echo "! No .zshrc.pre-oh-my-zsh found (clean install)"
    # oh-my-zshが作った.zshrcをそのまま使う
fi

# shared設定の読み込みを追加
echo ""
echo "Adding shared config loader..."
if ! grep -q "\.zshrc\.shared" "$HOME/.zshrc"; then
    cat >> "$HOME/.zshrc" << 'EOF'

# Load shared dotfiles configuration
if [[ -f ~/.zshrc.shared ]]; then
    source ~/.zshrc.shared
fi
EOF
    echo "✓ Shared config loader added"
else
    echo "! Shared config loader already exists"
fi

# Install zsh-autosuggestions
echo ""
echo "Installing zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "✓ zsh-autosuggestions installed successfully"