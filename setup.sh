#!/bin/bash

DOTFILES_DIR=${HOME}/dotfiles

echo "Deploying gitconfig..."

if [ -f "${DOTFILES_DIR}/.gitconfig" ]; then
    mkdir -p "${HOME}/.config/git"
    ln -sf "${DOTFILES_DIR}/.gitconfig" "${HOME}/.config/git/config"
    echo ".gitconfig deployed to ~/.config/git/config"
else
    echo "Error: .gitconfig not found"
    exit 1
fi
