#! /bin/bash

# Set up the current user's account to use the files in src/ as their dotfiles.

# If arguments are passed, each one is a filename to install from src/.

dotfiles_dir=$(dirname $0)
source $dotfiles_dir/lib/functions.sh
dotfiles_dir=$(abspath $dotfiles_dir)

src_dir="$dotfiles_dir/src/"
files_to_install=$(ls $src_dir)
if [[ $# -gt 0 ]]; then
    files_to_install="$@"
fi

# Install Karabiner (KeyRemap4Macbook on older OS Xs) preferences if necessary.
karabiner_name="Karabiner"
if [[ -d "/Applications/KeyRemap4MacBook.app" ]]; then
    karabiner_name="KeyRemap4MacBook"
fi

karabiner_xml_path="$HOME/Library/Application Support/$karabiner_name"
if [[ -d "$karabiner_xml_path" && ! -h "$karabiner_xml_path/private.xml" ]]; then
    rm -f "$karabiner_xml_path/private.xml"
    ln -s "$dotfiles_dir/lib/karabiner/private.xml" "$karabiner_xml_path/private.xml"
fi

karabiner_conf_path="$HOME/Library/Preferences"
if [[ -d "$karabiner_conf_path" && ! -h "$karabiner_conf_path/org.pqrs.$karabiner_name.plist" ]]; then
    rm -f "$karabiner_conf_path/org.pqrs.$karabiner_name.plist"
    # Karabiner doesn't like symlinks for its preferences file - it replaces
    # them with a real file. Copying back and forth seems to be the best we can
    # do, since git operations would break a hardlink.
    cp "$dotfiles_dir/lib/karabiner/org.pqrs.Karabiner.plist" "$karabiner_conf_path/org.pqrs.$karabiner_name.plist"
fi

for filename in $files_to_install;
do
    # GRIPE This install path logic should be in a function so it's not
    # duplicated between install.sh/uninstall.sh.
    target_path="$HOME/.$filename"
    if [ "$filename" = "gitconfig" ]; then
        # Install gitconfig to secondary git config path, so ~/.gitconfig can
        # be used to override settings per-machine. This is handy for
        # working on an employer's machine, so you can default repos to your
        # work email address but keep your other git settings.
        # Note: Older gits will not read from this path.
        target_path="$HOME/.config/git/config"
    fi

    if [ -e "$target_path" ]; then
        echo "$HOME/.$filename already exists. Not overwriting." >&2
    else
        target_dir=$(dirname "$target_path")
        mkdir -p "$target_dir"
        ln -s "$src_dir/$filename" "$target_path"
    fi
done
