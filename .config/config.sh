#!/bin/zsh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# .configディレクトリを作成
mkdir -p "$HOME/.config"

# .configディレクトリ内の各ディレクトリをループ
for config_dir in "${SCRIPT_DIR}"/* ; do
    # config.sh自体をスキップ
    [[ "$config_dir" == "${SCRIPT_DIR}/config.sh" ]] && continue
    # .DS_Storeをスキップ
    [[ "$config_dir" == "${SCRIPT_DIR}/.DS_Store" ]] && continue
    # ディレクトリのみ処理
    [[ ! -d "$config_dir" ]] && continue

    # ディレクトリ名を取得
    dir_name="$(basename "$config_dir")"

    # シンボリックリンクを作成
    ln -fnsv "$config_dir" "$HOME/.config/$dir_name"
done
