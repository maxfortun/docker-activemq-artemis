#!/bin/bash -ex

pushd "$(dirname $0)"
SWD=$(pwd)
BWD=$(dirname "$SWD")
popd
HOST_MNT=${HOST_MNT:-$BWD/mnt}
GUEST_MNT=${GUEST_MNT:-$BWD/mnt}

. $SWD/setenv.sh

docker build ${DOCKER_BUILD_ARGS[*]} --rm -t "$REPO/$NAME:$VERSION" $BWD/docker

dockerImages=$(docker images "$REPO/$NAME" -f "before=$REPO/$NAME:$VERSION" -q)
[ -n "$dockerImages" ] && docker rmi -f $dockerImages || true
