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

# Update the Makefile
make update-versions

URL=$(grep '^URL' Makefile  | awk '{ print $3 }')
VERSION=$(perl -pe "s#^.*/${PKG}-([\d\.]+|[0-9a-f]{6,})\.[^/]+\$#\$1#" <<< ${URL})
CURRENT_URL=$(perl -pe 's/^(\s*URL\s*:\s*)\S+/\$1/' ${PKG}.spec)
CURRENT_VERSION="$(rpmspec --srpm -q --qf="%{VERSION}" $PKG.spec)"

if [[ u"${CURRENT_URL}" == u"${URL}" ]]; then
	echo "Current version is still current: ${CURRENT_URL}"
	exit
fi

perl -pi -e "s|${CURRENT_URL}|${URL}|g" ${PKG}.spec
perl -pi -e "s|${CURRENT_VERSION}|${VERSION}|g" ${PKG}.spec

make generateupstream || exit 3

make bumpnogit
git add $PKG.spec Makefile release upstream
git commit -s -m "Update to ${VERSION}"
make koji-nowait
