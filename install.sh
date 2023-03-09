#! /usr/bin/env bash

# Set up the current user's account to use the files in src/ as their dotfiles.

platform="$(uname -s)"

dotfiles_dir=$(dirname $0)
source $dotfiles_dir/lib/functions.sh
dotfiles_dir=$(abspath $dotfiles_dir)

src_dir="$dotfiles_dir/src/"
# TODO Figure out why I didn't just symlink .config and be done with it. Seems
# like that should have worked?
config_dir="$dotfiles_dir/.config"
bin_dir="$dotfiles_dir/bin"

mkdir -p "$config_dir"

config_files_to_install=$(cd "$dotfiles_dir"; find src -maxdepth 1)
# TODO Make this a straight symlink to the .config folder? I don't understand
# why I didn't do that originally.
config_dirs_to_install=$(cd "$dotfiles_dir"; find .config -maxdepth 1)

"$bin_dir/install-crontab"

if command -v notmuch > /dev/null; then
    install-notmuch-hooks
fi


for filename in $config_files_to_install;
do
    filename="$(basename "$filename")"
    target_path="$HOME/$filename"

    if [ "$filename" == "." ] || [ "$filename" == ".." ]; then
        continue
    fi

    if [ -e "$target_path" ]; then
        echo "$target_path already exists. Not overwriting." >&2
    else
        target_dir=$(dirname "$target_path")
        mkdir -p "$target_dir"
        ln -s "$src_dir/$filename" "$target_path"
    fi
done

for filename in $config_dirs_to_install; do
    target_path="$HOME/$filename"

    if [ -e "$target_path" ]; then
        echo "$target_path already exists. Not overwriting." >&2
    else
        ln -s "$dotfiles_dir/$filename" "$HOME/$filename"
    fi

done

if [ $platform == 'Darwin' ] ; then
    "$bin_dir/set-os-x-defaults"

    echo "OS X preferences set.

You will need to log out for all changes to take effect."

    "$bin_dir/install-syncthing-launchd-job"

    echo "Don't forget to run the following after installing Nix:

$bin_dir/fix-tmux-terminal-not-fully-functional-macos"
fi

# Install Anonymous Pro font.
#
# TODO Figure out if there's a way to check whether it's already installed.

open_binary=open
if [ "$platform" == "Linux" ]; then
    open_binary=xdg-open
fi

$open_binary "$dotfiles_dir/anonymous-pro-font/"*.ttf
