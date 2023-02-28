#!/bin/bash

build_dir="build"
echo "Starting build..."

test -d "$build_dir" && { echo "Removing existing build directory"; rm -rf "$build_dir"; }
mkdir "$build_dir"

cp -r configs "$build_dir/"
cp -r launchpad "$build_dir/"
cp -r scripts "$build_dir/"

cp check_for_outdated_vars.sh "$build_dir/"
cp createBuild.sh "$build_dir/"
cp gendocs.sh "$build_dir/"
cp .gitignore "$build_dir/.gitignore"
echo "configs/local_config.json" >> "$build_dir/.gitignore"

mkdir "$build_dir/src"
mkdir "$build_dir/docs-data"
mkdir -p "$build_dir/docs/revisions"

python3 configure_build.py "$build_dir"

cd "$build_dir"
python3 scripts/docugen.py init

echo "Build complete"
