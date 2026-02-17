#!/bin/bash

unset GIT_ASKPASS
unset VSCODE_GIT_ASKPASS_MAIN
unset VSCODE_GIT_ASKPASS_NODE
unset VSCODE_GIT_ASKPASS_EXTRA_ARGS

GIT_CREDS_DEST="$HOME/.git-credentials"

echo "================================="
echo "      GIT CREDENTIALS MANAGER"
echo "================================="


OS_TYPE="$(uname -s)"

case "$OS_TYPE" in
    MINGW*|MSYS*|CYGWIN*)
        PLATFORM="windows"
        ;;
    Linux*)
        PLATFORM="linux"
        ;;
    Darwin*)
        PLATFORM="macos"
        ;;
    *)
        PLATFORM="unknown"
        ;;
esac

echo "[*] Detected OS: $PLATFORM"
echo ""
echo "--- GIT IDENTITY MANAGER ---"
echo "1) Switch Global Configuration (.gitconfig)"
echo "2) Switch Global Credentials (.git-credentials)"
echo "3) Show Current Identity"
echo "4) Exit"
read -p "Select an option: " main_opt

case $main_opt in
    1)
        files=($(ls *config* 2>/dev/null))
        if [ ${#files[@]} -eq 0 ]; then
            echo "No config files found."
            exit 1
        fi

        for i in "${!files[@]}"; do
            echo "$i) ${files[$i]}"
        done
        read -p "Select file: " file_idx
        selected_file=${files[$file_idx]}

        if [ ! -f "$selected_file" ]; then
            echo "Selected file does not exist."
            exit 1
        fi

        if [ "$PLATFORM" = "windows" ]; then
            SYSTEM_GITCONFIG="/c/Program Files/Git/etc/gitconfig"
            echo "[*] Copying $selected_file → $SYSTEM_GITCONFIG"
            cp "$selected_file" "$SYSTEM_GITCONFIG" 2>/dev/null || {
                echo "[!] Failed. Run Git Bash as Administrator."
                exit 1
            }
            echo "[✓] System gitconfig overwritten with $selected_file"
        else
            GLOBAL_GITCONFIG="$HOME/.gitconfig"
            cp "$selected_file" "$GLOBAL_GITCONFIG"
            echo "[✓] Global gitconfig updated to $selected_file"

            if grep -q "^\[credential\]" "$GLOBAL_GITCONFIG"; then
                if grep -q "helper" "$GLOBAL_GITCONFIG"; then
                    sed -i 's/helper *= *.*/helper = store/g' "$GLOBAL_GITCONFIG"
                else
                    sed -i '/^\[credential\]/a\    helper = store' "$GLOBAL_GITCONFIG"
                fi
            else
                echo "" >> "$GLOBAL_GITCONFIG"
                echo "[credential]" >> "$GLOBAL_GITCONFIG"
                echo "    helper = store" >> "$GLOBAL_GITCONFIG"
            fi
        fi
        ;;

    2)
        files=($(ls *credentials* 2>/dev/null))
        if [ ${#files[@]} -eq 0 ]; then
            echo "No credentials files found."
            exit 1
        fi

        for i in "${!files[@]}"; do
            echo "$i) ${files[$i]}"
        done
        read -p "Select file: " file_idx
        selected_file=${files[$file_idx]}

        if [ ! -f "$selected_file" ]; then
            echo "Selected file does not exist."
            exit 1
        fi

        cp "$selected_file" "$GIT_CREDS_DEST"
        chmod 600 "$GIT_CREDS_DEST"
        echo "[✓] Credentials updated and permissions set."
        ;;

    3)
        echo ""
        echo "---- CURRENT IDENTITY ----"

        if [ "$PLATFORM" = "windows" ]; then
            SYSTEM_GITCONFIG="/c/Program Files/Git/etc/gitconfig"
            echo "System gitconfig: $SYSTEM_GITCONFIG"
            if [ -f "$SYSTEM_GITCONFIG" ]; then
                grep -A2 "^\[user\]\|\[credential\]" "$SYSTEM_GITCONFIG"
            fi
        else
            GLOBAL_GITCONFIG="$HOME/.gitconfig"
            echo "Global gitconfig: $GLOBAL_GITCONFIG"
            if [ -f "$GLOBAL_GITCONFIG" ]; then
                grep -A2 "^\[user\]\|\[credential\]" "$GLOBAL_GITCONFIG"
            fi
        fi

        echo ""
        echo "Credentials file: $GIT_CREDS_DEST"
        if [ -f "$GIT_CREDS_DEST" ]; then
            head -n 3 "$GIT_CREDS_DEST"
        fi
        echo "----------------------------"
        ;;

    4)
        exit 0
        ;;

    *)
        echo "Invalid option."
        ;;
esac
