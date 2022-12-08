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

sleep 2

# Variables

EXECUTE=shentud
CHAIN_ID=shentu-2.2
PORT=56
SYSTEM_FOLDER=.shentud
PROJECT_FOLDER=shentu
VERSION=v2.6.0
REPO=https://github.com/ShentuChain/shentu.git
GENESIS_FILE=https://raw.githubusercontent.com/ShentuChain/mainnet/main/shentu-2.2/genesis.json
BIN_FILES_URL=https://raw.githubusercontent.com/ShentuChain/mainnet/main/shentu-2.2/statesync/state_sync.sh 
ADDRBOOK=
MIN_GAS=0
DENOM=uctk
SEEDS=3fddc0e55801f89f27a1644116e9ddb16a951e80@3.80.87.219:26656,4814cb067fe0aef705c4d304f0caa2362b7c4246@54.167.122.47:26656,f42be55f76b7d3425f493e54d043e65bfc6f43cb@54.227.66.150:26656,3edd4e16b791218b623f883d04f8aa5c3ff2cca6@shentu-seed.panthea.eu:36656
PEERS=b0690ba7a9cf755fc46486d45b5fd30d0da443de@78.47.143.61:26656,5b73f98db91d006f7da1db22244bc316f6b3742e@167.86.69.137:26656,bba10290da32f3cb41e15c3a192413666ce05cee@136.243.119.240:26656,471518432477e31ea348af246c0b54095d41352c@78.47.210.208:26656,41fe2472fa15299065af6a3d1cb97b910166d702@65.108.78.167:11756,100aee4f6928d09e3dddfd0c5028cf127509bbd9@162.55.132.48:15607,8a210f1bcfc9015a7bc18dcc5add29c0dce3f2dc@135.181.173.64:26656,db927f396ebc0cef65729961c732a19821834226@141.95.98.27:26656,897b95141cb391d69dd8a49cb36ec8c7a7ae9981@5.9.97.174:15607,6cceba286b498d4a1931f85e35ea0fa433373057@78.47.208.96:26656,eeea9639f366d7184db0f1ad60122957da82d734@135.181.113.227:2407,ccb2ecbb3897a39a5b5aa945c343591c7f582bee@23.88.69.22:28356,0494d17e2cbe835c7e85a073c7c4f0b6dc17d834@31.7.207.245:27756,207c47bed435e4174844064ef3f51ca35b059de2@194.163.172.37:26656,a605e6fa81adf6e510da9a819103e4244d97cdff@54.241.84.226:26656,fa2f75920fcea2589587fa2ff9a661b498b3c5b7@195.201.172.9:15607,40d3832c2f6409e039c01ab9494c7d705fe54dc8@213.136.80.20:26656,9023d9a3d60f147514129aabe6f6b60cfa4ee128@194.195.213.37:26656,e1754812621b14c4a993dd354a85421538284da4@89.58.59.44:26656,2ab182095835f907bb351c020c56aafaf662b93c@149.102.148.1:26666,06374bc14ea48a3ac4ad29258ba252739bf240f5@85.10.193.146:26656

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
echo "export SEED=${SEED}" >> $HOME/.bash_profile
echo "export MIN_GAS=${MIN_GAS}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
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

sudo apt update && sudo apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y && sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils htop net-tools lsof -y < "/dev/null"  && sudo apt-get update -y 
sudo apt-get install wget liblz4-tool aria2 -y 

ver="1.19.3"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

sleep 1

git clone $REPO
cd $PROJECT_FOLDER
git checkout $VERSION ; make install

sleep 1

$EXECUTE config chain-id $CHAIN_ID
$EXECUTE config keyring-backend file
$EXECUTE init $MONIKER --chain-id $CHAIN_ID

if [ $BIN_FILES_URL ]; then
    wget -qO- $BIN_FILES_URL | tar xvz -C $HOME/$SYSTEM_FOLDER/
	$EXECUTE tendermint unsafe-reset-all
fi

set -ux
set -e
set -v

# Please, update to RPC_ADDR to 3.236.161.42:26657 if you like to use Certik official RPC Node
# Given address is DSRV RPC Node Address.
RPC_ADDR="165.232.72.33:26657"
INTERVAL=1500

LATEST_HEIGHT=$(curl -s $RPC_ADDR/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$(($LATEST_HEIGHT-$INTERVAL))
TRUST_HASH=$(curl -s "$RPC_ADDR/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

# TELL USER WHAT WE ARE DOING
echo "TRUST HEIGHT: $BLOCK_HEIGHT"
echo "TRUST HASH: $TRUST_HASH"

export SHENTUD_STATESYNC_ENABLE=true
export SHENTUD_STATESYNC_RPC_SERVERS="$RPC_ADDR,$RPC_ADDR"
export SHENTUD_STATESYNC_TRUST_HEIGHT=$BLOCK_HEIGHT
export SHENTUD_STATESYNC_TRUST_HASH=$TRUST_HASH

# ADDRBOOK and GENESIS
if [ $GENESIS_FILE ]; then
	wget $GENESIS_FILE -O $HOME/$SYSTEM_FOLDER/config/genesis.json
fi
if [ $ADDRBOOK ]; then
	wget $ADDRBOOK -O $HOME/$SYSTEM_FOLDER/config/addrbook.json
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
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$SYSTEM_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$SYSTEM_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$SYSTEM_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$SYSTEM_FOLDER/config/app.toml

# PORTS

sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:2${PORT}8\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:2${PORT}7\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:2${PORT}6\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":2${PORT}0\"%" $HOME/$SYSTEM_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:2${PORT}7\"%; s%^address = \":8080\"%address = \":${PORT}80\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}91\"%" $HOME/$SYSTEM_FOLDER/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:2${PORT}7\"%" $HOME/$SYSTEM_FOLDER/config/client.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/$SYSTEM_FOLDER/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.000025$DENOM\"/" $HOME/$SYSTEM_FOLDER/config/app.toml

sleep 1 
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/$SYSTEM_FOLDER/config/config.toml

$EXECUTE tendermint unsafe-reset-all --home $HOME/$SYSTEM_FOLDER

# Creating your systemd service
sudo tee /etc/systemd/system/$EXECUTE.service > /dev/null <<EOF
[Unit]
Description=$EXECUTE
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which $EXECUTE) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable $EXECUTE
sudo systemctl restart $EXECUTE

echo '=============== SETUP IS FINISHED ==================='
echo -e "CHECK OUT YOUR LOGS : \e[1m\e[32mjournalctl -fu ${EXECUTE} -o cat\e[0m"
echo -e "CHECK SYNC: \e[1m\e[32msystemctl status $EXECUTE\e[0m"

source $HOME/.bash_profile