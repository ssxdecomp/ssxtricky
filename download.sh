#!/usr/bin/env bash
#
# Fetch the pinned toolchain: the decompals PS2 binutils, and the ee-gcc 2.9
# the game was built with. objdiff is fetched too, at its latest release, since
# it only compares objects and does not affect what the build produces.
#
# Both versions are pinned on purpose. A matching build needs the toolchain's
# output to be reproducible, and tracking `latest` would let an upstream release
# change what this project produces with no commit here -- and quietly put
# contributors on different toolchains. Bump the versions when you mean to.
set -euo pipefail

BINUTILS_VERSION="v0.10"
BINUTILS_URL="https://github.com/decompals/binutils-mips-ps2-decompals/releases/download/${BINUTILS_VERSION}/binutils-mips-ps2-decompals-linux-x86-64.tar.gz"
BINUTILS_SHA256="9fe31ea3ee1a37536f9f0e2e12c668e7c3cb99e59f5154bd2f1fc4762473094c"

# ee-gcc as decomp.me publishes it. decomp.me carries several near-identical
# 991111 builds, and the checksum is what makes sure this is ours (-01).
CC_VERSION="ee-gcc2.9-991111-01"
CC_URL="https://github.com/decompme/compilers/releases/download/compilers/${CC_VERSION}.tar.xz"
CC_SHA256="ed684fd98f89d36b0121caab311052089103e3b36241fcef4338cc9ea41c75b8"

cd "$(dirname "${BASH_SOURCE[0]}")"

# fetch <dest> <version> <url> [sha256]
fetch() {
	local dest="$1" version="$2" url="$3" want="${4:-}"
	local stamp="$dest/.version"

	if [[ -f "$stamp" ]] && [[ "$(cat "$stamp")" == "$version" ]]; then
		echo "$dest is already at $version, nothing to do."
		return 0
	fi

	# An existing tree is either unpinned or on the wrong version. Replacing it is
	# the whole point of the stamp -- without this, bumping a pin would do nothing.
	if [[ -d "$dest" ]]; then
		echo "Replacing $dest ($(cat "$stamp" 2>/dev/null || echo "unpinned")) with $version"
		rm -rf "$dest"
	fi

	echo "Fetching $version into $dest"

	local tmp
	tmp="$(mktemp -t ssxdvd-fetch-XXXXXX)"
	# shellcheck disable=SC2064  # expand $tmp now, not when the trap fires
	trap "rm -f '$tmp'" RETURN

	curl --fail --location --show-error --silent "$url" -o "$tmp"

	if [[ -n "$want" ]]; then
		local got
		got="$(sha256sum "$tmp" | cut -d' ' -f1)"
		if [[ "$got" != "$want" ]]; then
			echo "error: $dest checksum mismatch" >&2
			echo "  expected $want" >&2
			echo "  got      $got" >&2
			echo "Refusing to install it. The pinned release may have been replaced." >&2
			return 1
		fi
	fi

	mkdir -p "$dest"
	tar -C "$dest" -xf "$tmp"
	echo "$version" >"$stamp"
}

fetch "tools/binutils" "$BINUTILS_VERSION" "$BINUTILS_URL" "$BINUTILS_SHA256"
fetch "tools/cc/ee-991111-01" "$CC_VERSION" "$CC_URL" "$CC_SHA256"

mkdir -p "tools/objdiff"
curl -sSL https://github.com/encounter/objdiff/releases/latest/download/objdiff-cli-linux-x86_64 -o tools/objdiff/objdiff-cli-linux-x86_64
curl -sSL https://github.com/encounter/objdiff/releases/latest/download/objdiff-linux-x86_64 -o tools/objdiff/objdiff-linux-x86_64

echo
echo "tools/binutils:          $BINUTILS_VERSION ($(./tools/binutils/mips-ps2-decompals-as --version | head -1))"
echo "tools/cc/ee-991111-01:   $CC_VERSION ($(./tools/cc/ee-991111-01/bin/ee-gcc -v 2>&1 | tail -1))"
