#! /bin/bash

# Generate a Tern.js definition file for all the cordova plugins in the current
# project.
#
# Assumes it's being run from the main project directory. Also (correctly)
# assumes tern and the cordova-plugins-tern-condense plugin are available in
# this repo's node_modules folder, which makes it hard to reuse outside of my
# dotfiles.
#
# Ideally I'd register this as an after-plugin-install hook, so that
# definitions are updated after each change to the plugin stack.
#
# Not sure how to register hooks without saving them to the project, and I
# don't like shoving my tooling details into a shared repo.
#
# It would also be nice if this auto-updated the .tern-project file to have the
# full list of currently-installed plugins. some cleverness with the json
# command could probably do that...


plugin_names=$(cordova plugins list | cut -d' ' -f1)

script_path=$(dirname "$0")
node_modules_path="$script_path/../lib/node_modules"

# TODO Find a way to dump all of this into one file.
#
# Either that or find a way to make tern load a bunch of files implicitly.
libs_json_arr=""
for plugin_name in $plugin_names; do
    "$node_modules_path/tern/bin/condense" \
        --plugin "$node_modules_path"/cordova-plugins-tern-condense/cordova-plugins-condense.js \
        "./plugins/$plugin_name/plugin.xml" > "./www/.tern-defs/$plugin_name.json"

    if [ -n "$libs_json_arr" ]; then
        libs_json_arr="$libs_json_arr,"
    fi

    libs_json_arr="$libs_json_arr\"$plugin_name\""
done

# A JSON string for a .tern-project file that does nothing but load all the
# condensed definitions we just generated.
project_json_for_plugins_only="{\"libs\": [$libs_json_arr]}"

# This monstrosity merges the above primitive .tern-project with our existing
# one, making sure to remove duplicate entries in libs.
#
# It's based on this discussion on GitHub:
# https://github.com/stedolan/jq/issues/502#issuecomment-50063847
#
# TODO Find a way to uniquify the libs field without hardcoding all known
# fields. That would be much more robust.
echo "$(cat ./www/.tern-project)" "$project_json_for_plugins_only" | \
  jq -s '[.[] | to_entries] | flatten | reduce .[] as $dot ({}; .[$dot.key] += $dot.value) | { loadEagerly: .loadEagerly, plugins: .plugins, libs: .libs | unique }' > './www/.tern-project.tmp' && mv './www/.tern-project'{.tmp,}
