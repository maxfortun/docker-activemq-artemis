#!/bin/ash -ex

cd $(dirname $0)

NAME=apache-artemis
VERSIONED_NAME=$NAME-$ACTIVEMQ_ARTEMIS_VERSION
ARCHIVE=$VERSIONED_NAME-bin.tar.gz
curl -o $ARCHIVE -L "https://www.apache.org/dyn/closer.cgi?filename=activemq/activemq-artemis/$ACTIVEMQ_ARTEMIS_VERSION/$ARCHIVE&action=download"
tar xvzf $ARCHIVE
mv $VERSIONED_NAME /opt/

/opt/$VERSIONED_NAME/bin/artemis create /var/lib/$NAME \
	--home /opt/$VERSIONED_NAME \
	--user artemis \
	--password simetraehcapa \
	--role amq \
	--require-login \
	--cluster-user artemisCluster \
	--cluster-password simetraehcaparetsulc 
	
