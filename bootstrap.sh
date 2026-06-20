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

if [ -d config ]; then
    mkdir -p "$HOME/.config"

    for config_file in config/*; do
        [ -e "$config_file" ] || continue

        FILE_NAME=`basename $config_file`
        FILE_HOME_NAME=$HOME/.config/$FILE_NAME

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
