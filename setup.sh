#!/bin/bash

buildDir="build"
sourceDir="source"

echo "Starting build..."

test -d $buildDir && { echo "Removing existing build directory"; rm -rf $buildDir; }
mkdir $buildDir

cp -r $sourceDir/* $buildDir/
cp $sourceDir/.gitignore $buildDir/

mkdir $buildDir/src
mkdir $buildDir/launchpad
mkdir $buildDir/launchpad/beta
mkdir $buildDir/launchpad/release
mkdir $buildDir/docs-data
mkdir $buildDir/cfg
mkdir $buildDir/docs

cd $buildDir
python3 scripts/docugen.py init

echo "Build complete"
