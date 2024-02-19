#! /usr/bin/env bash

# Install homebrew packages listed in lib/homebrew-packages.txt.
#
# This makes it easy to keep my work and home machines running the same set of
# tools (or at least close - this doesn't lock versions, which I'm sure will
# bite me eventually).
#
# TODO Get all brew-installed packages into my nix config instead.
#
# Note that shortcat is awesome and I don't know how I lived without it.
if ! command -v brew > /dev/null; then
    echo 'Homebrew must be installed to install Homebrew packages!' >&2

    exit 1
fi

bin_dir=$(dirname "$0")
project_dir=$(dirname "$bin_dir")
homebrew_package_list="$project_dir/lib/homebrew-packages.txt"

declare -a packages_to_install
while read -r package || [[ -n "$package" ]]; do
    if ! bru ls --versions "$package" > /dev/null; then
        packages_to_install+=("$package")
    fi
done < "$homebrew_package_list"

for package in "${packages_to_install[@]}"; do
    bru install "$package"
done
