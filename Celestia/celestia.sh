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

if [ ! $MONIKER ]; then
	read -p "ENTER MONIKER NAME: " MONIKER
	echo 'export MONIKER='$MONIKER >> $HOME/.node101
    source ~/.node101
fi

sleep 1

# Updates

sudo apt update && sudo apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y && sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils htop net-tools lsof -y < "/dev/null"  && sudo apt-get update -y 
sudo apt-get install wget liblz4-tool aria2 -y 

ver="1.19.3"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.node101
source ~/.node101
go version


VERSION=v0.6.0
echo "export VERSION=${VERSION}" >> $HOME/.node101
source ~/.node101
sleep 1
PROJECT_FOLDER=celestia-app
echo "export PROJECT_FOLDER=${PROJECT_FOLDER}" >> $HOME/.node101
source ~/.node101
REPO=https://github.com/celestiaorg/celestia-app.git
echo "export REPO=${REPO}" >> $HOME/.node101
source ~/.node101
git clone $REPO
cd $PROJECT_FOLDER
git checkout $VERSION ; make install

EXECUTE=celestia-appd
echo "export EXECUTE=${EXECUTE}" >> $HOME/.node101
source ~/.node101
sleep 1

CHAIN_ID=mamaki
echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.node101
source ~/.node101
$EXECUTE config chain-id $CHAIN_ID
$EXECUTE config keyring-backend file
$EXECUTE init $MONIKER --chain-id $CHAIN_ID

#if [ $SNAP_NAME ]; then
#     wget -qO- $SNAP_NAME | tar xvz -C $HOME/$SYSTEM_FOLDER/data
#fi

SYSTEM_FOLDER=.celestia-app
echo "export SYSTEM_FOLDER=${SYSTEM_FOLDER}" >> $HOME/.node101
source ~/.node101
cd $HOME
rm -rf ~/$SYSTEM_FOLDER/data
mkdir -p ~/$SYSTEM_FOLDER/data
SNAP_NAME=$(curl -s https://snaps.qubelabs.io/celestia/ | \
    egrep -o ">mamaki.*tar" | tr -d ">")
wget -O - https://snaps.qubelabs.io/celestia/${SNAP_NAME} | tar xf - \
    -C ~/$SYSTEM_FOLDER/data/
$EXECUTE tendermint unsafe-reset-all --home $HOME/$SYSTEM_FOLDER

sleep 1

# ADDRBOOK and GENESIS

GENESIS_FILE=https://raw.githubusercontent.com/celestiaorg/networks/master/mamaki/genesis.json
echo "export GENESIS_FILE=${GENESIS_FILE}" >> $HOME/.node101
source ~/.node101
wget $GENESIS_FILE -O $HOME/$SYSTEM_FOLDER/config/genesis.json
ADDRBOOK=
echo "export ADDRBOOK=${ADDRBOOK}" >> $HOME/.node101
source ~/.node101
if [ $ADDRBOOK ]; then
	wget $ADDRBOOK -O $HOME/$SYSTEM_FOLDER/config/addrbook.json
fi


SEEDS=
echo "export SEED=${SEED}" >> $HOME/.node101
source ~/.node101
#PEERS=e4429e99609c8c009969b0eb73c973bff33712f9@141.94.73.39:43656,09263a4168de6a2aaf7fef86669ddfe4e2d004f6@142.132.209.229:26656,13d8abce0ff9565ed223c5e4b9906160816ee8fa@94.62.146.145:36656,72b34325513863152269e781d9866d1ec4d6a93a@65.108.194.40:26676,322542cec82814d8903de2259b1d4d97026bcb75@51.178.133.224:26666,5273f0deefa5f9c2d0a3bbf70840bb44c65d835c@80.190.129.50:49656,7145da826bbf64f06aa4ad296b850fd697a211cc@176.57.189.212:26656,5a4c337189eed845f3ece17f88da0d94c7eb2f9c@209.126.84.147:26656,ec072065bd4c6126a5833c97c8eb2d4382db85be@88.99.249.251:26656,cd1524191300d6354d6a322ab0bca1d7c8ddfd01@95.216.223.149:26656,2fd76fae32f587eceb266dce19053b20fce4e846@207.154.220.138:26656,1d6a3c3d9ffc828b926f95592e15b1b59b5d8175@135.181.56.56:26656,fe2025284ad9517ee6e8b027024cf4ae17e320c9@198.244.164.11:26656,fcff172744c51684aaefc6fd3433eae275a2f31b@159.203.18.242:26656,f7b68a491bae4b10dbab09bb3a875781a01274a5@65.108.199.79:20356,6c076056fc80a813b26e24ba8d28fa374cd72777@149.102.153.197:26656,180378bab87c9cecea544eb406fcd8fcd2cbc21b@168.119.122.78:26656,88fa96d09a595a1208968727819367bd2fe8eabe@164.70.120.56:26656,84133cfde6e5fcaf5915436d56b3eef1d1996d17@45.132.245.56:26656,42b331adaa9ece4c455b92f0d26e3382e46d43f0@161.97.180.20:36656,c8c0456a5174ab082591a9466a6e0cb15c915a65@194.233.85.193:26656,6a62bf1f489a5231ddc320a2607ab2595558db75@154.12.240.49:26656,d0b19e4d133441fd41b4d74ac8de2138313ad49e@195.201.41.137:26656,bf199295d4c142ebf114232613d4796e6d81a8d0@159.69.110.238:26656,a46bbdb81e66c950e3cdbe5ee748a2d6bdb185dd@161.97.168.77:26656,831cd61b04ac95155f101723b851af53460d4d65@65.108.217.169:26656,550ab50ad0df01408928a3479e643286a47b4fc9@46.4.213.197:26656,43e9da043318a4ea0141259c17fcb06ecff816af@141.94.73.39:43656,45d0154bea2e0bbffec343894072f5feab19d242@65.108.71.92:43656,2e4084408b641a90c299a499c32874f0ab0f2956@65.108.44.149:22656,de6ba05f3ed583a12c396c182e5126ed65a32514@154.53.44.239:26656,d6fb487ff10d9878449beaa89007da15ec43057f@194.163.137.209:26656,f0c58d904dec824605ac36114db28f1bf84f6ea3@144.76.112.238:26656
#echo "export PEERS=${PERS}" >> $HOME/.node101
#source ~/.node101

BOOTSTRAP_PEERS=$(curl -sL https://github.com/celestiaorg/networks/blob/master/mamaki/peers.txt | tr -d '\n')
echo $BOOTSTRAP_PEERS
source ~/.node101

sed -i.bak -e "s/^bootstrap-peers *=.*/bootstrap-peers = \"$BOOTSTRAP_PEERS\"/" $HOME/.celestia-app/config/config.toml

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

PORT=56
echo "export PORT=${PORT}" >> $HOME/.node101
source ~/.node101
DENOM=utia
echo "export DENOM=${DENOM}" >> $HOME/.node101
source ~/.node101
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:2${PORT}8\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:2${PORT}7\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:2${PORT}6\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":2${PORT}0\"%" $HOME/$SYSTEM_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}7\"%; s%^address = \":8080\"%address = \":${PORT}80\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}91\"%" $HOME/$SYSTEM_FOLDER/config/app.toml
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
echo -e "CHECK SYNC: \e[1m\e[32mcurl -s localhost:${PORT}657/status | jq .result.sync_info\e[0m"

source ~/.node101

if [ ! $WALLET_NAME ]; then
	read -p "ENTER WALLET NAME : " WALLET_NAME
	echo 'export WALLET_NAME='$WALLET_NAME >> $HOME/.node101
fi

$EXECUTE keys add $WALLET_NAME

echo -e "=================== \e[1m\e[32mPlease write your wallet name, than your password twice and save your mnemonics !\e[0m ==================="