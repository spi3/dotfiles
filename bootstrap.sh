#!/usr/bin/env sh

PWD=`pwd`
for dotfile in dotfiles/*; do

    FILE_NAME=`basename $dotfile`
    FILE_HOME_NAME=~/.$FILE_NAME

    rm -f $FILE_HOME_NAME

    echo Linking $FILE_NAME to $FILE_HOME_NAME
    ln -s $PWD/$dotfile $FILE_HOME_NAME
    
done
