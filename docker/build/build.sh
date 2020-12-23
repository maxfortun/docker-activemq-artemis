#!/bin/ash -ex

cd $(dirname $0)

NAME=apache-artemis
VERSIONED_NAME=$NAME-$ACTIVEMQ_ARTEMIS_VERSION
ARCHIVE=$VERSIONED_NAME-bin.tar.gz
curl -o $ARCHIVE -L "https://www.apache.org/dyn/closer.cgi?filename=activemq/activemq-artemis/$ACTIVEMQ_ARTEMIS_VERSION/$ARCHIVE&action=download"
tar xvzf $ARCHIVE
mv $VERSIONED_NAME /opt/

[ -n $ACTIVEMQ_ARTEMIS_CLUSTER_USER ] && ACTIVEMQ_ARTEMIS_CLUSTER_PARAMS="$ACTIVEMQ_ARTEMIS_CLUSTER_PARAMS --cluster-user $ACTIVEMQ_ARTEMIS_CLUSTER_USER"
[ -n $ACTIVEMQ_ARTEMIS_CLUSTER_PASSWORD ] && ACTIVEMQ_ARTEMIS_CLUSTER_PARAMS="$ACTIVEMQ_ARTEMIS_CLUSTER_PARAMS --cluster-user $ACTIVEMQ_ARTEMIS_CLUSTER_PASSWORD"

/opt/$VERSIONED_NAME/bin/artemis create /var/lib/$NAME \
	--home /opt/$VERSIONED_NAME \
	--user $ACTIVEMQ_ARTEMIS_USER \
	--password $ACTIVEMQ_ARTEMIS_PASSWORD \
	--role amq \
	--require-login \
	$ACTIVEMQ_ARTEMIS_CLUSTER_PARAMS

sed -i 's/localhost/0.0.0.0/g' /var/lib/apache-artemis/etc/bootstrap.xml
sed -i 's#<cors>#<cors>\n\t<allow-origin>*://192.168.*</allow-origin>#g' /var/lib/apache-artemis/etc/jolokia-access.xml
