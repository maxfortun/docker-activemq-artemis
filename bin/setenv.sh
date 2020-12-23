REPO=local
NAME=activemq-artemis
VERSION=0.0.1

DOCKER_PORT_PREFIX=40

DOCKER_BUILD_ARGS=( --build-arg HOME=$HOME )
DOCKER_BUILD_ARGS+=( --build-arg REPO=$REPO )
DOCKER_BUILD_ARGS+=( --build-arg NAME=$NAME )
DOCKER_BUILD_ARGS+=( --build-arg VERSION=$VERSION )

DOCKER_BUILD_ARGS+=( --build-arg ACTIVEMQ_ARTEMIS_VERSION=2.16.0 )
DOCKER_BUILD_ARGS+=( --build-arg ACTIVEMQ_ARTEMIS_USER=$(cat $GUEST_MNT/local/artemis-user) )
DOCKER_BUILD_ARGS+=( --build-arg ACTIVEMQ_ARTEMIS_PASSWORD=$(cat $GUEST_MNT/local/artemis-password) )

#if netstat -an|grep -q \.3128.*LISTEN; then
	#proxy_ip=$(ifconfig -a|grep inet.*192.168.|awk '{ print $2}')
	#DOCKER_BUILD_ARGS+=( --build-arg http_proxy=http://$proxy_ip:3128 --build-arg https_proxy=https://$proxy_ip:3128 )
#fi

