sudo apt-get update
sudo apt-get upgrade

# Install java
sudo apt-get install openjdk-8-jdk openjdk-8-source
sudo ln -s /usr/lib/jvm/java-1.8.0-openjdk-amd64 /opt/jdk
echo '' >> ~/.bashrc
echo 'export JAVA_HOME="/opt/jdk"' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
#update-alternatives --install /usr/bin/java java /opt/jdk/java-8-openjdk-amd64/bin/java 10

# Install kafka (Source) (https://docs.confluent.io/current/installation/installing_cp.html)
wget http://packages.confluent.io/archive/4.0/confluent-oss-4.0.0-2.11.tar.gz
tar xvzf confluent-oss-4.0.0-2.11.tar.gz
sudo mv confluent-4.0.0 /opt/
sudo ln -s /opt/confluent-4.0.0 /opt/confluent
echo 'export CONFLUENT_HOME="/opt/confluent"' >> ~/.bashrc
echo 'export PATH=$CONFLUENT_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Start kafka
confluent start
confluent status

# (1) Try simple kafka
kafka-avro-console-producer \
         --broker-list localhost:9092 --topic test \
         --property value.schema='{"type":"record","name":"myrecord","fields":[{"name":"f1","type":"string"}]}'
## Insert this following key-value
{"f1": "value1"}
{"f1": "value2"}
{"f1": "value3"}

kafka-avro-console-consumer --topic test \
         --zookeeper localhost:2181 \
         --from-beginning

# (2) Producer via REST with Avro schema; Consume to console
## a. Create topic
kafka-topics --zookeeper localhost:2181 --create --topic test1 --partitions 1 --replication-factor 1
## b. Define schema
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
    --data '{"schema": "{\"type\": \"record\", \"name\": \"User\", \"fields\": [{\"name\": \"name\", \"type\": \"string\"}]}"}' \
     http://localhost:8081/subjects/test1-value/versions
curl -X GET http://localhost:8081/subjects/test1-value/versions
## c. Send data via REST
curl -X POST -H "Content-Type: application/vnd.kafka.avro.v2+json" -H "Accept: application/vnd.kafka.v2+json" --data '{"value_schema_id":1, "records": [{"value": {"name": "testUser"}}]}' "http://localhost:8082/topics/test1"
## d. Consume to console
kafka-avro-console-consumer --topic test1 --zookeeper localhost:2181 --from-beginning

confluent stop

# (3) Producer via REST without Avro schema; Consume to console
# $CONFLUENT_HOME/bin/zookeeper-server-start $CONFLUENT_HOME//etc/kafka/zookeeper.properties
# $CONFLUENT_HOME/bin/kafka-server-start $CONFLUENT_HOME//etc/kafka/server.properties
# $CONFLUENT_HOME/bin/kafka-rest-start $CONFLUENT_HOME//etc/kafka-rest/kafka-rest.properties

## a. Create topic
kafka-topics --zookeeper localhost:2181 --create --topic test2 --partitions 1 --replication-factor 1
## b. Send data via REST
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" -H "Accept: application/vnd.kafka.v2+json" --data '{"records":[{"value":{"foo":"bar"}}]}' "http://localhost:8082/topics/test2"
## c. Consume to console
kafka-console-consumer --topic test2 \
         --zookeeper localhost:2181 \
         --from-beginning

confluent stop
# $CONFLUENT_HOME/bin/zookeeper-server-stop
# $CONFLUENT_HOME/bin/kafka-server-stop
# $CONFLUENT_HOME/bin/kafka-rest-stop

# TRY Kafka consumer
curl -X POST -H "Content-Type: application/vnd.kafka.v2+json" -H "Accept: application/vnd.kafka.v2+json" \
    --data '{"name": "test2-instance", "format": "json", "auto.offset.reset": "earliest"}' \
    http://localhost:8082/consumers/test2-group

