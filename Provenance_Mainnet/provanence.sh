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

EXECUTE=provenanced
CHAIN_ID=pio-mainnet-1
PORT=65
SYSTEM_FOLDER=.provenanced
PROJECT_FOLDER=provenance
VERSION=v1.13.0
REPO=https://github.com/provenance-io/provenance.git
GENESIS_FILE=https://raw.githubusercontent.com/SynergyNodes/provenance-io-mainnet/main/genesis.json
SNAP_NAME=$(curl -s https://tools.highstakes.ch/files/provenance/data_2022-12-19.tar.gz | \
    egrep -o ">data_2022-12-19.*tar.gz" | tr -d ">")
ADDRBOOK=https://raw.githubusercontent.com/sergiomateiko/addrbooks/main/Provenanced/addrbook.json
DENOM=nhash
SEEDS=4bd2fb0ae5a123f1db325960836004f980ee09b4@seed-0.provenance.io:26656,048b991204d7aac7209229cbe457f622eed96e5d@seed-1.provenance.io:26656
PEERS=b89a4c8ec3527ebf9b79c5e24b6f3bfc3a97f9f3@rpc.provenance.ppnv.space:15656,c9cc9b23fb0e7b78200a09059085bd45a313a65b@161.35.131.13:26656,51d967d19fb1d0c9c23c03035c1e810fc2d73aac@159.89.136.160:26656
SEED_MODE="true"

sleep 2

echo "export EXECUTE=${EXECUTE}" >> $HOME/.bash_profile
echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.bash_profile
echo "export PORT=${PORT}" >> $HOME/.bash_profile
echo "export SYSTEM_FOLDER=${SYSTEM_FOLDER}" >> $HOME/.bash_profile
echo "export PROJECT_FOLDER=${PROJECT_FOLDER}" >> $HOME/.bash_profile
echo "export VERSION=${VERSION}" >> $HOME/.bash_profile
echo "export REPO=${REPO}" >> $HOME/.bash_profile
echo "export GENESIS_FILE=${GENESIS_FILE}" >> $HOME/.bash_profile
echo "export PEERS=${PEERS}" >> $HOME/.bash_profile
echo "export SEEDS=${SEEDS}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
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
sudo apt install pkg-config build-essential libssl-dev curl jq git libleveldb-dev -y
sudo apt-get install manpages-dev -y

ver="1.19.1"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version

sleep 1
cd $HOME
git clone $REPO ; 
cd $PROJECT_FOLDER
git checkout tags/$VERSION ; make clean ; make install 

sleep 1

$EXECUTE init $MONIKER --chain-id $CHAIN_ID

#GENESIS AND DATA FILES
wget $GENESIS_FILE -O $HOME/$SYSTEM_FOLDER/config/genesis.json
if [ $GENESIS_FILE ]; then
    wget -qO- $GENESIS_FILE | tar xvz -C $HOME/$SYSTEM_FOLDER/
fi
if [ $ADDRBOOK ]; then
    wget -qO- $ADDRBOOK | tar xvz -C $HOME/$SYSTEM_FOLDER/
fi

cd ~/.provenanced/config
rm genesis.json
rm app.toml
rm config.toml

wget https://raw.githubusercontent.com/SynergyNodes/provenance-io-mainnet/main/genesis.json
wget https://raw.githubusercontent.com/SynergyNodes/provenance-io-mainnet/main/app.toml
wget https://raw.githubusercontent.com/SynergyNodes/provenance-io-mainnet/main/config.toml

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

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.celestia-app/config/app.toml

#Validator mode on
sed -i.bak -e "s/^mode *=.*/mode = \"validator\"/" $HOME/$SYSTEM_FOLDER/config/config.toml

#Reset network
$EXECUTE tendermint unsafe-reset-all --home $HOME/$SYSTEM_FOLDER


cd $HOME
rm -rf ~/$SYSTEM_FOLDER/data
mkdir -p ~/$SYSTEM_FOLDER/data
SNAP_NAME=$(https://tools.highstakes.ch/files/provenance/data_2022-12-19.tar.gz | \
    egrep -o ">data_2022-12-19.*tar.gz" | tr -d ">")
wget -O - https://snaps.qubelabs.io/celestia/${SNAP_NAME} | tar xf - \
    -C ~/$SYSTEM_FOLDER/data/


# Creating your systemd service
sudo tee <<EOF >/dev/null /etc/systemd/system/EXECUTE.service
[Unit]
Description=Provenance Daemon
#After=network.target
StartLimitInterval=350
StartLimitBurst=10

[Service]
Type=simple
User=node
ExecStart=$(which $EXECUTE) start --home $HOME/$SYSTEM_FOLDER  --x-crisis-skip-assert-invariants
Restart=on-abort
RestartSec=30

[Install]
WantedBy=multi-user.target

[Service]
LimitNOFILE=1048576
EOF

echo '=============== SETUP IS FINISHED ==================='
echo -e "CHECK OUT YOUR LOGS : \e[1m\e[32mjournalctl -fu ${EXECUTE} -o cat\e[0m"
echo -e "CHECK SYNC: \e[1m\e[32mcurl -s localhost:2${PORT}67/status | jq .result.sync_info\e[0m"

source $HOME/.bash_profile