# Exploration of Confluent Kafka

This example is using Ubuntu 16.04 (LTS)

## Update Ubuntu
```
sudo apt-get update
sudo apt-get upgrade
```

## Install Java
```
sudo apt-get install openjdk-8-jdk openjdk-8-source
sudo ln -s /usr/lib/jvm/java-1.8.0-openjdk-amd64 /opt/jdk
```
Insert this lines to '/etc/profile.d/custom.sh'
> export JAVA_HOME="/opt/jdk"
> export PATH=$JAVA_HOME/bin:$PATH
```
source /etc/profile.d/custom.sh
```

## Install kafka
Source: https://docs.confluent.io/current/installation/installing_cp.html
```
wget http://packages.confluent.io/archive/4.0/confluent-oss-4.0.0-2.11.tar.gz
tar xvzf confluent-oss-4.0.0-2.11.tar.gz
sudo mv confluent-4.0.0 /opt/
sudo ln -s /opt/confluent-4.0.0 /opt/confluent
```
Insert this lines to '/etc/profile.d/custom.sh'
> export CONFLUENT_HOME="/opt/confluent"
> export PATH=$CONFLUENT_HOME/bin:$PATH
```
source /etc/profile.d/custom.sh
```

