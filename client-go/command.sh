# Install Go with its requirements
sudo apt-get -f update
sudo apt-get -y upgrade
sudo curl -O https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz
sudo tar -xvf go1.9.2.linux-amd64.tar.gz
sudo mv go /usr/local
sudo ln -s /usr/local/go /opt/go
sudo touch /etc/profile.d/custom.sh
sudo echo 'export GOROOT=/opt/go' >> /etc/profile.d/custom.sh
sudo echo 'export PATH=$PATH:$GOROOT/bin' >> /etc/profile.d/custom.sh
source /etc/profile.d/custom.sh
sudo mkdir $GOROOT/work
sudo chmod 777 /opt/go/work
sudo echo 'export GOPATH=/opt/go/work' >> /etc/profile.d/custom.sh
source /etc/profile.d/custom.sh
sudo apt-get install -y pkg-config lxc-dev

# Install librdkafka
cd ~
git clone https://github.com/edenhill/librdkafka.git
sudo mv librdkafka /opt/
cd /opt/librdkafka
./configure --prefix /usr
make
sudo make install
echo 'export PKG_CONFIG_PATH="/opt/librdkafka/src"' >> /etc/profile.d/custom.sh
source /etc/profile.d/custom.sh
cd ~

# Install kafka go client
sudo /opt/go/bin/go get -u github.com/confluentinc/confluent-kafka-go/kafka

# Pull from git
mkdir kafka-client-go && cd kafka-client-go
git init
git remote add origin https://github.com/ardittot/kafka-go-client-explore.git
git pull origin master
