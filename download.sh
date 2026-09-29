#!/usr/bin/env bash
#
# Fetch objdiff into tools/objdiff, and the decompals PS2 binutils into
# tools/binutils.
#
# The binutils version is pinned on purpose. A matching build needs the
# assembler's output to be reproducible, and tracking `latest` would let an
# upstream release change what this project produces with no commit here -- and
# quietly put contributors on different toolchains. Bump BINUTILS_VERSION when
# you mean to.
set -euo pipefail

BINUTILS_VERSION="v0.10"
BINUTILS_URL="https://github.com/decompals/binutils-mips-ps2-decompals/releases/download/${BINUTILS_VERSION}/binutils-mips-ps2-decompals-linux-x86-64.tar.gz"

cd "$(dirname "${BASH_SOURCE[0]}")"

mkdir -p "tools/objdiff"
curl -sSL https://github.com/encounter/objdiff/releases/latest/download/objdiff-cli-linux-x86_64 -o tools/objdiff/objdiff-cli-linux-x86_64
curl -sSL https://github.com/encounter/objdiff/releases/latest/download/objdiff-linux-x86_64 -o tools/objdiff/objdiff-linux-x86_64

DEST="tools/binutils"
STAMP="$DEST/.version"

if [[ -f "$STAMP" ]] && [[ "$(cat "$STAMP")" == "$BINUTILS_VERSION" ]]; then
	echo "tools/binutils is already at $BINUTILS_VERSION, nothing to do."
	echo "Delete $DEST if you want to force a re-download."
	exit 0
fi

# An existing tree is either unpinned or on the wrong version. Replacing it is the
# whole point of the stamp -- without this, bumping the pin above would do nothing.
if [[ -d "$DEST" ]]; then
	echo "Replacing $DEST ($(cat "$STAMP" 2>/dev/null || echo "unpinned")) with $BINUTILS_VERSION"
	rm -rf "$DEST"
fi

mkdir -p "$DEST"
curl --fail --location --show-error --silent "$BINUTILS_URL" | tar -C "$DEST" -xzf -
echo "$BINUTILS_VERSION" >"$STAMP"

echo "tools/binutils: $BINUTILS_VERSION ($(./"$DEST"/mips-ps2-decompals-as --version | head -1))"
