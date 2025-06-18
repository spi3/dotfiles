#!/usr/bin/env sh

set -x
echo "Running bootstrap"

UNAME=`uname`

# Run macOS setup if the system is Darwin
if [ "$UNAME" = "Darwin" ]; then
  sh macos_setup.sh
else if [ "$UNAME" = "Linux" ]; then
  sh linux_setup.sh
fi

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

PWD=`pwd`
for dotfile in dotfiles/*; do

    FILE_NAME=`basename $dotfile`
    FILE_HOME_NAME=$HOME/.$FILE_NAME

    rm -f $FILE_HOME_NAME

    echo Linking $FILE_NAME to $FILE_HOME_NAME
    ln -s $PWD/$dotfile $FILE_HOME_NAME
    
done




