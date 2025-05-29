#!/bin/bash

# Variables
DOTFILES_DIR=~/dotfiles
BACKUP_DIR=~/dotfiles_backup

echo "Setting up .bashrc and git-completion.bash from $DOTFILES_DIR..."

# create a dotfile directory if it doesn't exist
mkdir -p $DOTFILES_DIR

# Create a backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Check if an existing .bashrc file exists in the home directory
if [ -f ~/.bashrc ]; then
    echo "Backing up existing .bashrc to $BACKUP_DIR/.bashrc_backup"
    cp ~/.bashrc $BACKUP_DIR/.bashrc_backup

    # Merge unique lines from the old .bashrc into the dotfiles .bashrc
    echo "Merging existing .bashrc with $DOTFILES_DIR/.bashrc"
    # Create a temp merged file
    awk 'NR==FNR{a[$0];next}!($0 in a)' $DOTFILES_DIR/.bashrc ~/.bashrc >> $DOTFILES_DIR/.bashrc
    # Remove the old .bashrc to allow symlink creation
    rm ~/.bashrc
fi

# Create a symlink to the .bashrc in the dotfiles directory
ln -sf $DOTFILES_DIR/.bashrc ~/.bashrc
echo "Symlink created: ~/.bashrc -> $DOTFILES_DIR/.bashrc"

# Source the new .bashrc to apply changes immediately
if [ -f ~/.bashrc ]; then
    echo "Sourcing the new .bashrc..."
    source ~/.bashrc
fi

# Check if an existing git-completion.bash file exists in the home directory
if [ -f ~/git-completion.bash ]; then
    echo "Backing up existing git-completion.bash to $BACKUP_DIR/git-completion.bash_backup"
    mv ~/git-completion.bash $BACKUP_DIR/git-completion.bash_backup
fi

# Create a symlink to the git-completion.bash in the dotfiles directory
ln -sf $DOTFILES_DIR/git-completion.bash ~/git-completion.bash
echo "Symlink created: ~/git-completion.bash -> $DOTFILES_DIR/git-completion.bash"

echo "Dotfiles setup complete!"