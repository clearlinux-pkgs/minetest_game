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

if [[ "$1" != "--force" ]]; then
	echo -n 'Update the local git repository: '
	git pull --ff-only
fi

echo 'Fetch the upstream releaseinfo'
release=$(curl -s https://content.luanti.org/api/packages/Minetest/minetest_game/releases/)

echo -n 'Find the title for the latest release: '
title=$(jq -r '.[0].title' <<< ${release})
echo ${title}

echo -n 'Find the commit hash for the latest release: '
hash=$(jq -r '.[0].commit' <<< ${release})
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
   if [[ "$1" != "--force" ]]; then
	   exit 0
   fi
fi

echo Update the Makefile
sed -i -e "s#^URL *=.*#URL = ${URL}#" Makefile
perl -pi -e "s|${CURRENT_URL}|${URL}|g" ${PKG}.spec
perl -pi -e "s|${CURRENT_VERSION}|${VERSION}|g" ${PKG}.spec

if [[ "$1" != "--force" ]]; then
	echo Check whether anything actually changed
	git diff --no-patch --exit-code Makefile ${PKG}.spec && errexit "No change to Makefile or specfile"
fi

echo Update the tarball
make generateupstream || exit 3

echo Commit the changes
make bumpnogit
git add ${PKG}.spec Makefile release upstream
# Generate commit message, including release notes for all versions since
# CURRENT_VERSION
(	echo "Update to ${title} ${VERSION}";
	echo;
	i=0;
	while [[ $(jq -r ".[$i].commit" <<< ${release} ) != ${CURRENT_VERSION} ]]; do
		jq -r ".[$i].release_notes" <<< ${release} ;
		((i++));
	done) | git commit -F -

echo Send the package to koji
make koji-nowait
