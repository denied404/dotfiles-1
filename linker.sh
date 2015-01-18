#!/bin/bash

POINTS=(
    "bin"
    ".config/dunst"
    ".config/redshift.conf"
    ".config/fontconfig"
    ".fonts"
    ".gitconfig"
    ".gitignore"
    ".gitignore_global"
    ".i3"
    ".i3status.conf"
    ".mcabber"
    ".muttator"
    ".muttatorrc"
    ".urxvt"
    ".vim/UltiSnips"
    ".vimperatorrc"
    ".vimrc"
    ".Xdefaults.dark"
    ".Xdefaults.light"
    ".xsessionrc"
    ".zpreztorc"
    ".zshrc"
)

for POINT in "${POINTS[@]}"; do
    COMMAND="rm -rf ~/$POINT"
    echo "$COMMAND"
    eval $COMMAND

    COMMAND="ln -sf ~/repos/dotfiles/$POINT ~/$POINT"
    echo "$COMMAND"
    eval $COMMAND
done
