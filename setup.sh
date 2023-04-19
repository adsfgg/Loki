#!/bin/bash

temp_install_dir="install"

# Error/Exit handling
trap 'on_error' ERR
function on_error() {
    rc=$?
    echo
    echo "ERROR at line ${LINENO} (rc: $rc)"
    echo "The installation did NOT complete successfully"
    exit $rc
}
set -euE

function download_latest_loki_release() {
    local tarballfile="loki.tar.gz"

    # Cleanup
    test -f $tarballfile && rm -f $tarballfile
    test -d $temp_install_dir && rm -rf $temp_install_dir

    echo "Fetching latest release..."

    # Find tarball URL, download and extract into temp_install_dir
    local tarball_url="$(curl -s "https://api.github.com/repos/adsfgg/Loki/releases/latest" | jq -r ".tarball_url")"
    curl -sLo $tarballfile "$tarball_url"
    mkdir $temp_install_dir
    tar -xzf $tarballfile -C $temp_install_dir --strip-components=1
    rm $tarballfile
}

function copy_release_data_to_dir() {
    cp -r "$temp_install_dir/launchpad" .

    cp "$temp_install_dir/create_build.sh" .
    cp "$temp_install_dir/.gitignore" .

    mkdir docs
}

function setup_project() {
    # Get the user to setup their project
    python3 "$temp_install_dir/configure_build.py"
}

function cleanup() {
    rm -rf $temp_install_dir
}

function main() {
    echo "Installing Loki..."

    download_latest_loki_release
    copy_release_data_to_dir
    setup_project
    cleanup

    echo "Installation complete!"
}

main $@
