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
cp .loki "$build_dir/.loki"
cp .gitignore "$build_dir/.gitignore"
echo "configs/local_config.json" >> "$build_dir/.gitignore"

mkdir "$build_dir/docs-data"
mkdir -p "$build_dir/docs/revisions"

python3 configure_build.py "$build_dir"
cd $build_dir
. scripts/shared_funcs.sh
mod_name="$(load_config_entry mod_name)"
revision_variable="$(load_config_entry revision_variable)"
beta_revision_variable="$(load_config_entry beta_revision_variable)"
balance_lua_file="$(load_config_entry balance_lua_file | cut -c 5-)"

# Setup src/ structure
mkdir -p "src/lua/$mod_name/"

# Setup Balance.lua
filepath="src/lua/$mod_name/Balance.lua"
touch $filepath
echo "-- Place your Balance.lua changes here" >> $filepath
echo "" >> $filepath
echo "-- e.g." >> $filepath
echo "-- kFadeHealth = 250" >> $filepath

# Setup FileHooks
filepath="src/lua/${mod_name}_FileHooks.lua"
touch $filepath
echo "$revision_variable = 1" >> $filepath
echo "$beta_revision_variable = 0" >> $filepath
echo >> $filepath
echo "-- Place your filehooks here" >> $filepath
echo >> $filepath
echo "ModLoader.SetupFileHook(\"lua/Balance.lua\", \"$balance_lua_file\", \"post\")" >> $filepath
echo >> $filepath

cd ..
find . -maxdepth 1 -not -name $build_dir -not -name . -not -name .. -exec rm -rf {} \;

mv $build_dir/* $build_dir/.gitignore .
rmdir $build_dir
python3 scripts/docugen.py init

echo "Build complete"
