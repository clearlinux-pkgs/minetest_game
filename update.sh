#!/bin/bash
set -e -o pipefail

PKG=minetest_game

errexit() {
	local ret=1
	echo "Error: $1"
	if [[ -n "$2" ]]; then
		ret=2
	fi
	exit $ret
}

git pull --ff-only

# Find the abbreviated commit hash for the latest release
hash=$(curl -s https://content.luanti.org/packages/Minetest/minetest_game/releases/ | grep -i -oE '\[[0-9a-f]+\]'  | head -1 | sed -e 's/[][]//g')

# Shallow-clone the repo and find the matching commit
repo=$(mktemp -d minetest-XXXXXX)
git clone --filter=tree:0 https://github.com/minetest/minetest_game.git ${repo}

# Get the non-abbreviated commit hash
hash=$(git -C ${repo} log --pretty=format:"%H" ${hash} -1)
rm -rf "${repo}"

if [[ "" == "${hash}" ]]; then
	errexit "Could not find commit hash for latest release"
fi

URL="https://github.com/minetest/minetest_game/archive/${hash}/minetest_game-${hash}.tar.gz"
VERSION=$(perl -pe "s#^.*/${PKG}-([\d\.]+|[0-9a-f]{6,})\.[^/]+\$#\$1#" <<< ${URL})
CURRENT_URL=$(perl -pe 's/^(\s*URL\s*:\s*)\S+/\$1/' ${PKG}.spec)
CURRENT_VERSION="$(rpmspec --srpm -q --qf="%{VERSION}" $PKG.spec)"

[[ u"${CURRENT_URL}" == u"${URL}" ]] && errexit "Current version is still current: ${CURRENT_URL}"

# Update the Makefile
sed -i -e "s#^URL *=.*#URL = ${URL}#" Makefile
perl -pi -e "s|${CURRENT_URL}|${URL}|g" ${PKG}.spec
perl -pi -e "s|${CURRENT_VERSION}|${VERSION}|g" ${PKG}.spec

# Check whether anything actually changed
git diff --no-patch --exit-code ${PKG}.spec && errexit "No change to Makefile or specfile"

# Update the tarball
make generateupstream || exit 3

make bumpnogit
git add ${PKG}.spec Makefile release upstream
git commit -s -m "Update to ${VERSION}"

make koji-nowait
