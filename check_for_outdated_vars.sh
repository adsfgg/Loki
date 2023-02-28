#!/bin/bash

. scripts/shared_funcs.sh

install_path="$(get_ns2_install_path)"
mod_src_dir="$(load_config_entry mod_src_dir)"
balance_lua_file="$(load_config_entry balance_lua_file)"

python3 scripts/var_checker.py \
    "$mod_src_dir" \
    "$balance_lua_file" \
    "$install_path/ns2/lua/Balance.lua" \
    "$install_path/ns2/lua/BalanceHealth.lua" \
    "$install_path/ns2/lua/BalanceMisc.lua"
exit $?
