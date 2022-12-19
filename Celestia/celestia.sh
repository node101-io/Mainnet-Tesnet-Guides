#! /bin/bash

echo -e '\e[0m'                                                              
echo -e '@@@  @@@   @@@@@@   @@@@@@@   @@@@@@@@    @@@   @@@@@@@@     @@@'
echo -e '@@@@ @@@  @@@@@@@@  @@@@@@@@  @@@@@@@@   @@@@  @@@@@@@@@@   @@@@'
echo -e '@@!@!@@@  @@!  @@@  @@!  @@@  @@!       @@@!!  @@!   @@@@  @@@!!'
echo -e '!@!!@!@!  !@!  @!@  !@!  @!@  !@!         !@!  !@!  @!@!@    !@!'
echo -e '@!@ !!@!  @!@  !@!  @!@  !@!  @!!!:!:     @!@  @!@ @! !@!    @!@'
echo -e '!@!  !!!  !@!  !!!  !@!  !!!  !!!!!::     !@!  !@!!!  !!!    !@!'
echo -e '!!:  !!!  !!:  !!!  !!:  !!!  !!:         !!:  !!:!   !!!    !!:'
echo -e ':!:  !:!  :!:  !:!  :!:  !:!  :!:         :!:  :!:    !:!    :!:'
echo -e ':::   ::   ::::::   :::::::   :::::::     :::   ::::::::     :::'
echo -e '\e[0m'

# Variables

SNAPSHOT_URL=https://snaps.qubelabs.io/celestia/mocha_2022-12-19.tar
EXECUTE=celestia-appd
CHAIN_ID=mocha
PORT=26
SYSTEM_FOLDER=.celestia-app
PROJECT_FOLDER=celestia-app
VERSION=v0.11.0
GO_VERSION="1.19.1"
REPO=https://github.com/celestiaorg/celestia-app.git
GENESIS_FILE=https://raw.githubusercontent.com/celestiaorg/networks/master/mocha/genesis.json
ADDRBOOK=
MIN_GAS=
DENOM=tia
SEEDS=8084e73b70dbe7fba3602be586de45a516012e6f@144.76.112.238:26656
PEERS=eaa763cde89fcf5a8fe44274a5ee3ce24bce2c5b@64.227.18.169:26656,0d0f0e4a149b50a96207523a5408611dae2796b6@198.199.82.109:26656,c2870ce12cfb08c4ff66c9ad7c49533d2bd8d412@178.170.47.171:26656,3584c49855123abdc16b01a47f9e1bea38a9db1b@154.26.155.102:26656
SEED_MODE="true"

sleep 2

echo "export SNAPSHOT_URL=${SNAPSHOT_URL}" >> $HOME/.bash_profile
echo "export EXECUTE=${EXECUTE}" >> $HOME/.bash_profile
echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.bash_profile
echo "export PORT=${PORT}" >> $HOME/.bash_profile
echo "export SYSTEM_FOLDER=${SYSTEM_FOLDER}" >> $HOME/.bash_profile
echo "export PROJECT_FOLDER=${PROJECT_FOLDER}" >> $HOME/.bash_profile
echo "export VERSION=${VERSION}" >> $HOME/.bash_profile
echo "export GO_VERSION=${GO_VERSION}" >> $HOME/.bash_profile
echo "export REPO=${REPO}" >> $HOME/.bash_profile
echo "export GENESIS_FILE=${GENESIS_FILE}" >> $HOME/.bash_profile
echo "export ADDRBOOK=${ADDRBOOK}" >> $HOME/.bash_profile
echo "export MIN_GAS=${MIN_GAS}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
echo "export SEEDS=${SEEDS}" >> $HOME/.bash_profile
echo "export PEERS=${PEERS}" >> $HOME/.bash_profile
echo "export SEED_MODE=${SEED_MODE}" >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 1

if [ ! $MONIKER ]; then
	read -p "ENTER MONIKER NAME: " MONIKER
	echo 'export MONIKER='$MONIKER >> $HOME/.bash_profile
fi

sleep 1

if [ ! $WALLET_NAME ]; then
	read -p "ENTER WALLET NAME : " WALLET_NAME
	echo 'export WALLET_NAME='$WALLET_NAME >> $HOME/.bash_profile
fi

# Updates

sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y

cd $HOME
wget "https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$GO_VERSION.linux-amd64.tar.gz"
rm "go$GO_VERSION.linux-amd64.tar.gz"

echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version

sleep 1

cd $HOME
rm -rf $PROJECT_FOLDER
git clone $REPO
cd $PROJECT_FOLDER
git checkout tags/$VERSION -b $VERSION
make install

sleep 1

$EXECUTE init $MONIKER --chain-id $CHAIN_ID

#GENESIS AND DATA FILES
wget $GENESIS_FILE -O $HOME/$SYSTEM_FOLDER/config/genesis.json
if [ $BIN_FILES_URL ]; then
    wget -qO- $BIN_FILES_URL | tar xvz -C $HOME/$SYSTEM_FOLDER/
fi
if [ $ADDRBOOK ]; then
    wget -qO- $ADDRBOOK | tar xvz -C $HOME/$SYSTEM_FOLDER/
fi


SEEDS="$SEEDS"
PEERS="$PEERS"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$SYSTEM_FOLDER/config/config.toml
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$SYSTEM_FOLDER/config/config.toml


sleep 1

# config prunings
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
source $HOME/.bash_profile

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$SYSTEM_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$SYSTEM_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$SYSTEM_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$SYSTEM_FOLDER/config/app.toml

#Validator mode on
sed -i.bak -e "s/^mode *=.*/mode = \"validator\"/" $HOME/$SYSTEM_FOLDER/config/config.toml

#Reset network
$EXECUTE tendermint unsafe-reset-all --home $HOME/$SYSTEM_FOLDER


cd $HOME
rm -rf ~/$SYSTEM_FOLDER/data
mkdir -p ~/$SYSTEM_FOLDER/data
wget -O - $SNAPSHOT_URL | tar xf - \
    -C ~/$SYSTEM_FOLDER/data/


# Creating your systemd service
sudo tee <<EOF >/dev/null /etc/systemd/system/$EXECUTE.service
[Unit]
Description=$EXECUTE Cosmos daemon
After=network-online.target
[Service]
User=$USER
ExecStart=$HOME/go/bin/$EXECUTE start
Restart=on-failure
RestartSec=3
LimitNOFILE=4096
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable $EXECUTE
sudo systemctl restart $EXECUTE

echo '=============== SETUP IS FINISHED ==================='
echo -e "CHECK OUT YOUR LOGS : \e[1m\e[32mjournalctl -fu ${EXECUTE} -o cat\e[0m"
echo -e "CHECK SYNC: \e[1m\e[32mcurl -s localhost:${PORT}657/status | jq .result.sync_info\e[0m"
source $HOME/.bash_profile

