## Sink data to hdfs
cp /opt/confluent/etc/kafka-connect-hdfs/quickstart-hdfs.properties /opt/confluent/etc/kafka-connect-hdfs/sink-test.properties
confluent load hdfs-sink -d /opt/confluent/etc/kafka-connect-hdfs/sink-test.properties
confluent log connect
