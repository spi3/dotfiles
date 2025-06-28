#!/usr/bin/env sh
#set -x

echo "Running macOS setup..."

# Install homebrew 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Installing Homebrew packages..."
brew bundle

# If ~/.profile directory does not exist then create it
if [ ! -d "$HOME/.profile" ]; then
  mkdir -p "$HOME/.profile"
fi

# Symlink the files within the macos/profile directory to ~/.profile
for dotfile in macos/profile/*; do
    FILE_NAME=`basename $dotfile`
    FILE_HOME_NAME=$HOME/.profile/$FILE_NAME

    rm -f $FILE_HOME_NAME

    echo Linking $FILE_NAME to $FILE_HOME_NAME
    ln -s $PWD/$dotfile $FILE_HOME_NAME
    
done
