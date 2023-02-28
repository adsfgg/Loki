#!/bin/bash

. scripts/shared_funcs.sh

filehooks_path="$(load_config_entry filehooks_path)"
mod_name="$(load_config_entry mod_name)"
lua_dir="$(load_config_entry lua_dir)"
balance_lua_file="$(load_config_entry balance_lua_file)"

install_path="get_ns2_install_path"

revision="$(get_revision)"
beta_revision="$(get_beta_revision)"
revision_string="$(get_revision_string "$revision" "$beta_revision")"

vanilla_build="$1"
shift

test -z "$vanilla_build" && { echo "Usage: $0 [vanilla_build]"; exit 1; }

echo "Generating docs for $mod_name revision $revision_string"

# Generate docs
revision_args="$revision"
if [ "$beta_revision" -ne 0 ]; then
    revision_args="$revision_args $beta_revision"
fi

python3 scripts/docugen.py gen \
    "$lua_dir" \
    "$install_path/ns2/lua" \
    "$mod_balance_path" \
    "$install_path/ns2/lua/Balance.lua" \
    "$install_path/ns2/lua/BalanceHealth.lua" \
    "$install_path/ns2/lua/BalanceMisc.lua" \
    "$vanilla_build" \
    $revision_args

test "$?" || { echo "ERROR: Docugen returned a non-zero return-code"; exit 1; }
