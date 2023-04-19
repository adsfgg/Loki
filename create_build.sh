#!/bin/bash

build_dir="build"

# Check for outstanding commits
test -d .git && test -n "$(git status --porcelain)" && { echo "ERROR: You have outstanding commits, please commit before creating a build"; exit 1; }

# Create build_dir (removing old directories if needed)
test -d "$build_dir" && { 
    echo "Removing old build directory";
    rm -rf "$build_dir";
}
mkdir "$build_dir"

# Copy over build data
cp launchpad/mod.settings "$build_dir/"
cp launchpad/preview.jpg "$build_dir/"
mkdir "$build_dir/source"
mkdir "$build_dir/output"

cp -r src/ "$build_dir/output/"

for file in LICENSE README.md; do
    test -f "$file" && cp "$file" "$build_dir/output/"
done

echo "Build created in $build_dir"
