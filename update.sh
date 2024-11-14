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

echo -n 'Update the local git repository: '
git pull --ff-only

echo -n 'Find the commit hash for the latest release: '
hash=$(curl -s https://content.luanti.org/api/packages/Minetest/minetest_game/releases/ | jq -r '.[0].commit')
echo ${hash}

if [[ "" == "${hash}" ]]; then
	errexit "Could not find commit hash for latest release"
fi

echo -n "Generate new URL                : "
URL="https://github.com/minetest/minetest_game/archive/${hash}/minetest_game-${hash}.tar.gz"
echo ${URL}
VERSION=$(perl -pe "s#^.*/${PKG}-([\d\.]+|[0-9a-f]{6,})\.[^/]+\$#\$1#" <<< ${URL})
CURRENT_URL=$(perl -ne 'm/^\s*URL\s*:\s*(\S+)/ && print $1' ${PKG}.spec)
CURRENT_VERSION="$(rpmspec --srpm -q --qf="%{VERSION}" $PKG.spec)"

if [[ "${CURRENT_URL}" == "${URL}" ]] && [[ "${CURRENT_VERSION}" == "${VERSION}" ]]; then
   echo "Current version is still current: ${CURRENT_URL}"
   exit 0
fi

echo Update the Makefile
sed -i -e "s#^URL *=.*#URL = ${URL}#" Makefile
perl -pi -e "s|${CURRENT_URL}|${URL}|g" ${PKG}.spec
perl -pi -e "s|${CURRENT_VERSION}|${VERSION}|g" ${PKG}.spec

echo Check whether anything actually changed
git diff --no-patch --exit-code Makefile ${PKG}.spec && errexit "No change to Makefile or specfile"

echo Update the tarball
make generateupstream || exit 3

echo Commit the changes
make bumpnogit
git add ${PKG}.spec Makefile release upstream
git commit -s -m "Update to ${VERSION}"

echo Send the package to koji
make koji-nowait
