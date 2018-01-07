# Exploration of Confluent Kafka

This example is using Ubuntu 16.04 (LTS)

## Preparation
#### Update Ubuntu
```
sudo apt-get update
sudo apt-get upgrade
```

#### Install Java
```
sudo apt-get install openjdk-8-jdk openjdk-8-source
sudo ln -s /usr/lib/jvm/java-1.8.0-openjdk-amd64 /opt/jdk
```
Insert this lines to _/etc/profile.d/custom.sh_
> export JAVA_HOME="/opt/jdk"
> 
> export PATH=$JAVA_HOME/bin:$PATH
```
source /etc/profile.d/custom.sh
```

#### Install kafka
Source: https://docs.confluent.io/current/installation/installing_cp.html
```
wget http://packages.confluent.io/archive/4.0/confluent-oss-4.0.0-2.11.tar.gz
tar xvzf confluent-oss-4.0.0-2.11.tar.gz
sudo mv confluent-4.0.0 /opt/
sudo ln -s /opt/confluent-4.0.0 /opt/confluent
```
Insert this lines to _/etc/profile.d/custom.sh_
> export CONFLUENT_HOME="/opt/confluent"
> export PATH=$CONFLUENT_HOME/bin:$PATH
```
source /etc/profile.d/custom.sh
```

## Examples
Start kafka cluster
```
confluent start
confluent status
```

#### 1) Producer and consumer via console
Initiate a producer
```
kafka-avro-console-producer \
         --broker-list localhost:9092 --topic test \
         --property value.schema='{"type":"record","name":"myrecord","fields":[{"name":"f1","type":"string"}]}'
```

Insert this following messages in the console
>>> {"f1": "value1"}
>>> {"f1": "value2"}
>>> {"f1": "value3"}

Start a console consumer in separated terminal
```
kafka-avro-console-consumer --topic test \
         --zookeeper localhost:2181 \
         --from-beginning
```

#### 2) Producer via REST with Avro schema; Consumer in the console
Create kafka topic
```
kafka-topics --zookeeper localhost:2181 --create --topic test1 --partitions 1 --replication-factor 1
```

Define schema
```
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
    --data '{"schema": "{\"type\": \"record\", \"name\": \"User\", \"fields\": [{\"name\": \"name\", \"type\": \"string\"}]}"}' \
     http://localhost:8081/subjects/test1-value/versions
curl -X GET http://localhost:8081/subjects/test1-value/versions
```

Send data via REST
```
curl -X POST -H "Content-Type: application/vnd.kafka.avro.v2+json" -H "Accept: application/vnd.kafka.v2+json" --data '{"value_schema_id":1, "records": [{"value": {"name": "testUser"}}]}' "http://localhost:8082/topics/test1"
```

Consume to console in separated terminal
```
kafka-avro-console-consumer --topic test1 --zookeeper localhost:2181 --from-beginning
```

#### 3) Producer via REST without Avro schema; Consume in the console
Create topic
```
kafka-topics --zookeeper localhost:2181 --create --topic test2 --partitions 1 --replication-factor 1
```

Send data via REST
```
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" -H "Accept: application/vnd.kafka.v2+json" --data '{"records":[{"value":{"foo":"bar"}}]}' "http://localhost:8082/topics/test2"
```

Consume to console
```
kafka-console-consumer --topic test2 \
         --zookeeper localhost:2181 \
         --from-beginning
```

#### Miscellaneous
Try kafka consumer group
```
curl -X POST -H "Content-Type: application/vnd.kafka.v2+json" -H "Accept: application/vnd.kafka.v2+json" \
    --data '{"name": "test2-instance", "format": "json", "auto.offset.reset": "earliest"}' \
    http://localhost:8082/consumers/test2-group
```

### Stop kafka cluster
```
confluent stop
```
