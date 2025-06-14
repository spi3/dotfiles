#!/usr/bin/env sh

set -x
echo "Running bootstrap"

UNAME=`uname`


# Install Homebrew packages if on macOS
if [ "$UNAME" = "Darwin" ]; then
  sh macos_setup.sh
fi

PWD=`pwd`
for dotfile in dotfiles/*; do

    FILE_NAME=`basename $dotfile`
    FILE_HOME_NAME=~/.$FILE_NAME

    rm -f $FILE_HOME_NAME

    echo Linking $FILE_NAME to $FILE_HOME_NAME
    ln -s $PWD/$dotfile $FILE_HOME_NAME
    
done

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"




