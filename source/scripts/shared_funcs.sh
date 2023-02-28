#!/bin/bash

function load_config_entry() {
    local key="$1"
    shift

    entry="$(jq --raw-output ".$key" configs/config.json 2>/dev/null)"
    test $? -eq 0 || {
        echo "Failed to get config entry \"$key\"" >&2;
        kill -SIGPIPE "$$";
    }
    
    echo "$entry"
    return 0
}

function get_ns2_install_path() {
    path="$(jq --raw-output ".ns2_install_path" configs/local_config.json 2>/dev/null)"
    test $? -eq 0 || {
        echo "No NS2 install path set. Please configure in configs/local_config.json" >&2;
        kill -SIGPIPE "$$";
    }

    echo "$path"
    return 0
}
