#!/bin/bash -ex

pushd "$(dirname $0)"
SWD=$(pwd)
PATH="$PATH:$SWD"
BWD=$(dirname "$SWD")

# Let's make sure jq is available
! which jq >/dev/null && curl -o $SWD/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-osx-amd64 && chmod a+x $SWD/jq

. $SWD/setenv.sh

RUN_IMAGE="$REPO/$NAME"

DOCKER_RUN_ARGS=( -e container=docker )
DOCKER_RUN_ARGS+=( -v /etc/resolv.conf:/etc/resolv.conf:ro )
#DOCKER_RUN_ARGS+=( --add-host host.docker.internal:host-gateway )

# Publish exposed ports
imageId=$(docker images --format="{{.Repository}} {{.ID}}"|grep "^$RUN_IMAGE "|awk '{ print $2 }')
while read port; do
	proto=${port##*/}
	portOnly=${port%/*}
	pad=$(( 5 - ${#portOnly} ))
	hostPort=${DOCKER_PORT_PREFIX:0:$pad}${port%%/*}
	[ ${#hostPort} -gt 5 ] && hostPort=${hostPort:${#hostPort}-5}
	DOCKER_RUN_ARGS+=( -p $hostPort:$port )
done < <(docker image inspect -f '{{json .Config.ExposedPorts}}' $imageId|jq -r 'keys[]')

HOST_MNT=${HOST_MNT:-$BWD/mnt}
GUEST_MNT=${GUEST_MNT:-$BWD/mnt}

DOCKER_RUN_ARGS+=( -v $GUEST_MNT/etc/squid/squid.conf:/etc/squid/squid.conf )
DOCKER_RUN_ARGS+=( -v $GUEST_MNT/etc/squid/conf.d:/etc/squid/conf.d )
DOCKER_RUN_ARGS+=( -v $GUEST_MNT/var/cache/squid:/var/cache/squid )

docker update --restart=no $NAME || true
docker stop $NAME || true
docker system prune -f
docker run -d -it --restart=always "${DOCKER_RUN_ARGS[@]}" --name $NAME $RUN_IMAGE:$VERSION "$@"

echo "To attach to container run 'docker attach $NAME'. To detach CTRL-P CTRL-Q."
[ "$DOCKER_ATTACH" != "true" ] || docker attach $NAME


