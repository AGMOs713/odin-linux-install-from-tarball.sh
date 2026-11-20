#!/bin/sh

# Author: AGMOs713 (agimota) <https://github.com/AGMOs713>
# Created: 20-11-2026
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a
# compiled binary, for any purpose, commercial or non-commercial,
# and by any means.
#
# In jurisdictions that recognize copyright laws, the author or
# authors of this software dedicate any and all copyright interest
# in the software to the public domain.
#
# If the above dedication is not recognized or enforceable in your
# jurisdiction, this software is alternatively licensed under the
# MIT No Attribution License (MIT-0).
#
# SPDX-License-Identifier: Unlicense OR MIT-0

case "$1" in
    help|-h|-help|--help)
	echo "Usage:"
	echo "  $0 [ help | -h | -help | --help ]   print this message"
	echo "  [sudo] $0 <TARBALL>                 install odin from TARBALL"
	exit 0
	;;
    # *)
    # 	echo "Usage:"
    # 	echo "  $0 [ help | -h | -help | --help ]   print this message"
    # 	echo "  [sudo] $0 <TARBALL>                 install odin from TARBALL"
    # 	exit 1
    # 	;;
esac

PREFIX=/usr/local
echo "Using $PREFIX as installation prefix."

echo "Checking dependencies..."
if command -v tar >/dev/null 2>&1; then
    :
else
    echo "$0: tar command not found in PATH."
    exit 1
fi

if command -v strip >/dev/null 2>&1; then
    :
else
    echo "$0: strip command not found in PATH. This command is optional."
fi

echo "Dependencies satisfied."

echo "Checking existence of '$1'..."
if [ -f "$1" ]; then
    echo "'$1' exists. Extraction may proceed."
else
    echo "'$1' not found. Make sure to specify the right file."
fi

echo "Extracting the name of tar destination directory..."
EXTDIR=$(tar tf "$1" | head -n 1 | cut -d/ -f1)
echo "Name of destination directory: $EXTDIR"

echo "Extracting $1..."
tar xf "$1" -C ./

if [ "$?" -ne 0 ]; then
    echo "$0: extraction failed. Make sure '$1' is the desired Odin tarball."
    exit 1
fi

echo "Extraction succeeded to directory '$EXTDIR'."

echo "Changing directory into $EXTDIR..."
cd "$EXTDIR"

missing=4
echo "Checking for expected files and directories..."
if command -v ./odin > /dev/null 2>&1; then
    missing=$((missing - 1))
fi

if [ -d base ]; then
    missing=$((missing - 1))
fi

if [ -d core ]; then
    missing=$((missing - 1))
fi

if [ -d vendor ]; then
    missing=$((missing - 1))
fi

if [ $missing -ne 0 ]; then
    echo "$0: one or more files or directories are missing inside the \
extracted archive directory. Missing: $missing"
    exit $missing
fi

echo "All files and directories found. Proceeding..."

if command -v strip >/dev/null 2>&1; then
    echo "ATTENTION: Stripping the 'odin' binary."
    strip odin
else
    echo "ATTENTION: NOT stripping the 'odin' binary."
fi

echo "Creating '$PREFIX/bin' directory (if it doesn't already exist)"
mkdir -p "$PREFIX/bin"

echo "Copying 'odin' binary to '$PREFIX/bin'..."
cp -f ./odin "$PREFIX/bin/"

echo "Copying 'base' directory to '$PREFIX/bin'..."
cp -rf ./base "$PREFIX/bin/"

echo "Copying 'core' directory to '$PREFIX/bin'..."
cp -rf ./core "$PREFIX/bin/"

echo "Copying 'vendor' directory to '$PREFIX/bin'..."
cp -rf ./vendor "$PREFIX/bin/"

echo "Testing install... \
(ATTENTION: 'vendor' directory is NOT tested for portability reasons)"

echo "Creating 'test-odin-installation.odin'..."
cat > test-odin-installation.odin <<EOF
package main

import "core:fmt"

main :: proc() {
    fmt.printf("Odin install is working!\n")
}
EOF

echo "Running 'test-odin-installation.odin'..."
odin run -file test-odin-installation.odin

if [ "$?" -ne 0 ]; then
    echo "Running 'test-odin-installation.odin' failed."
    exit 1
fi

echo "Installation successful!"

echo "Not running cleanup for debug reasons."

exit
