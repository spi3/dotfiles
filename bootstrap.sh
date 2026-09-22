#!/usr/bin/env sh

#set -x
echo "Running bootstrap"

UNAME=`uname`

# Run macOS setup if the system is Darwin
if [ "$UNAME" = "Darwin" ]; then
  sh macos_setup.sh
elif [ "$UNAME" = "Linux" ]; then
  sh linux_setup.sh
fi

# Homebrew installs pi on macOS. Use npm as a cross-platform fallback,
# installing into ~/.local so the command does not require sudo.
install_pi() {
    if command -v pi >/dev/null 2>&1; then
        return 0
    fi

    if ! command -v npm >/dev/null 2>&1; then
        echo "Cannot install pi because npm is not available"
        return 1
    fi

    echo "Installing pi coding agent..."
    npm install -g --ignore-scripts --prefix "$HOME/.local" @earendil-works/pi-coding-agent || return 1
    export PATH="$HOME/.local/bin:$PATH"
    hash -r

    if ! command -v pi >/dev/null 2>&1; then
        echo "Pi was installed, but the pi command is not available on PATH"
        return 1
    fi
}

install_pi || exit 1

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Set zsh as default shell
echo "Setting zsh as default shell..."
chsh -s $(which zsh)

PWD=`pwd`
for dotfile in dotfiles/*; do

    FILE_NAME=`basename $dotfile`
    FILE_HOME_NAME=$HOME/.$FILE_NAME

    rm -f $FILE_HOME_NAME

    echo Linking $FILE_NAME to $FILE_HOME_NAME
    ln -s $PWD/$dotfile $FILE_HOME_NAME
    
done

# Link command-line scripts into ~/.local/bin
if [ -d scripts ]; then
    mkdir -p "$HOME/.local/bin"

    for script_file in scripts/*; do
        [ -e "$script_file" ] || continue

        FILE_NAME=`basename "$script_file"`
        FILE_HOME_NAME=$HOME/.local/bin/$FILE_NAME

        if [ -L "$FILE_HOME_NAME" ]; then
            rm -f "$FILE_HOME_NAME"
        elif [ -e "$FILE_HOME_NAME" ]; then
            echo "Skipping $FILE_HOME_NAME because it already exists and is not a symlink"
            continue
        fi

        echo Linking "$FILE_NAME" to "$FILE_HOME_NAME"
        ln -s "$PWD/$script_file" "$FILE_HOME_NAME"
    done
fi

if [ -d config ]; then
    mkdir -p "$HOME/.config"

    for config_file in config/*; do
        [ -e "$config_file" ] || continue

        FILE_NAME=`basename $config_file`
        FILE_HOME_NAME=$HOME/.config/$FILE_NAME

        # Herdr keeps runtime logs, sockets, and session state beside config.toml,
        # so link only its tracked config files instead of the whole directory.
        if [ "$FILE_NAME" = "herdr" ] && [ -d "$config_file" ]; then
            mkdir -p "$FILE_HOME_NAME"

            for herdr_file in "$config_file"/*; do
                [ -e "$herdr_file" ] || continue

                HERDR_FILE_NAME=`basename "$herdr_file"`
                HERDR_FILE_HOME_NAME=$FILE_HOME_NAME/$HERDR_FILE_NAME

                if [ -L "$HERDR_FILE_HOME_NAME" ]; then
                    rm -f "$HERDR_FILE_HOME_NAME"
                elif [ -e "$HERDR_FILE_HOME_NAME" ]; then
                    echo "Skipping $HERDR_FILE_HOME_NAME because it already exists and is not a symlink"
                    continue
                fi

                echo Linking "$HERDR_FILE_NAME" to "$HERDR_FILE_HOME_NAME"
                ln -s "$PWD/$herdr_file" "$HERDR_FILE_HOME_NAME"
            done
            continue
        fi

        if [ -L "$FILE_HOME_NAME" ]; then
            rm -f "$FILE_HOME_NAME"
        elif [ -e "$FILE_HOME_NAME" ]; then
            echo "Skipping $FILE_HOME_NAME because it already exists and is not a symlink"
            continue
        fi

        echo Linking $FILE_NAME to $FILE_HOME_NAME
        ln -s $PWD/$config_file $FILE_HOME_NAME
    done
fi

# Link pi config without touching auth.json, sessions, or trust.json
link_pi_config() {
    PI_CONFIG_SOURCE=$1
    PI_CONFIG_HOME=$2
    PI_CONFIG_NAME=`basename "$PI_CONFIG_SOURCE"`

    if [ -L "$PI_CONFIG_HOME" ]; then
        rm -f "$PI_CONFIG_HOME"
    elif [ -e "$PI_CONFIG_HOME" ]; then
        echo "Skipping $PI_CONFIG_HOME because it already exists and is not a symlink"
        return
    fi

    echo Linking "$PI_CONFIG_NAME" to "$PI_CONFIG_HOME"
    ln -s "$PWD/$PI_CONFIG_SOURCE" "$PI_CONFIG_HOME"
}

if [ -d pi ]; then
    mkdir -p "$HOME/.pi/agent"

    for pi_file in pi/*; do
        [ -f "$pi_file" ] || [ -L "$pi_file" ] || continue
        FILE_NAME=`basename "$pi_file"`
        link_pi_config "$pi_file" "$HOME/.pi/$FILE_NAME"
    done

    for pi_file in pi/agent/*; do
        [ -e "$pi_file" ] || continue
        FILE_NAME=`basename "$pi_file"`
        link_pi_config "$pi_file" "$HOME/.pi/agent/$FILE_NAME"
    done

    # Install or update every package declared in the linked global settings.
    echo "Installing configured pi packages..."
    PI_CODING_AGENT_DIR="$HOME/.pi/agent" pi update --extensions || exit 1
fi
