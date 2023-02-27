#!/bin/bash

echo "Starting build..."

test -d build && rm -rf build
mkdir build

mkdir build/src
mkdir build/launchpad
mkdir build/docs-data
mkdir build/cfg

echo "Build complete"
