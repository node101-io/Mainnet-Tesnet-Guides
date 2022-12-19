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


EXECUTE=aapd
CHAIN_ID=
PORT=56
SYSTEM_FOLDER=.
PROJECT_FOLDER=
VERSION=v2.3.3
REPO=https://github.com/bandprotocol/chain.git
GENESIS_FILE=https://raw.githubusercontent.com/bandprotocol/launch/master/laozi-mainnet/genesis.json
BIN_FILES_URL=https://raw.githubusercontent.com/bandprotocol/launch/master/laozi-mainnet/files.tar.gz
ADDRBOOK=https://dl2.quicksync.io/json/addrbook.band.json
MIN_GAS=0
DENOM=uband
SEEDS=7490c272d1c9db40b7b9b61b0df3bb4365cb63a6@loyal-seed.netdots.net:26656,b66ecdf36bb19a9af0460b3ae0901aece93ae006@pubnode1.joinloyal.io:26656
PEERS=

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
echo "export MIN_GAS=${MIN_GAS}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
source $HOME/.bash_profile


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




sleep 1

if [ ! $CHAIN_NAME ]; then
	read -p "ENTER CHAIN_NAME : " PLEASE_ADD_YOUR_NEW_CHAIN_NAME
	echo 'export CHAIN_NAME='$CHAIN_NAME >> $HOME/.bash_profile

fi

sleep 1

git clone https://github.com/ignite/cli --depth=1 ; cd cli && make install  ; cd $CHAIN_NAME

ignite chain serve  >> $HOME/.bash_profile

ignite scaffold chain $CHAIN_NAME





sleep 1

if [ ! $WALLET_NAME ]; then
	read -p "ENTER WALLET NAME : " WALLET_NAME
	echo 'export WALLET_NAME='$WALLET_NAME >> $HOME/.bash_profile
fi



git clone $REPO
cd $PROJECT_FOLDER
git checkout $VERSION ; make install

sleep 1

$EXECUTE config chain-id $CHAIN_ID
$EXECUTE init $CHAIN_NAME --chain-id $CHAIN_ID

if [ $BIN_FILES_URL ]; then
    wget -qO- $BIN_FILES_URL | tar xvz -C $HOME/$SYSTEM_FOLDER/
fi


# ADDRBOOK and GENESIS
wget $GENESIS_FILE -O $HOME/$SYSTEM_FOLDER/config/genesis.json
wget $ADDRBOOK -O $HOME/$SYSTEM_FOLDER/config/addrbook.json

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
echo "[Unit]
Description=$EXECUTE service
After=network.target
[Service]
User=$USER
Type=simple
ExecStart=$(which $EXECUTE) start
Restart=on-failure
Restart=on-failure
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target" > $HOME/$EXECUTE.service

sudo mv $HOME/$EXECUTE.service /etc/systemd/system/

sudo systemctl daemon-reload

sudo systemctl enable $EXECUTE
sudo systemctl restart $EXECUTE && journalctl -u $EXECUTE -f -o cat 

sudo systemctl daemon-reload
sudo systemctl enable $EXECUTE
sudo systemctl restart $EXECUTE

echo -e '\e[0m'                                                              
echo -e '@@@  @@@@@@@@ @@@  @@@ @@@ @@@@@@@ @@@@@@@@'
echo -e '@@@ @@@@@@@@@ @@@@ @@@ @@@ @@@@@@@ @@@@@@@@'
echo -e '@@! !@@       @@!@!@@@ @@!   @@!   @@!     '
echo -e '!@! !@!       !@!!@!@! !@!   !@!   !@!     '
echo -e '!!@ !@! @!@!@ @!@ !!@! !!@   @!!   @!!!:!  '
echo -e '!!! !!! !!@!! !@!  !!! !!!   !!!   !!!!!:  '
echo -e '!!: :!!   !!: !!:  !!! !!:   !!:   !!:     '
echo -e ':!: :!:   !:: :!:  !:! :!:   :!:   :!:     '
echo -e ' ::  ::: ::::  ::   ::  ::    ::    :: ::::'
echo -e ':    :: :: :  ::    :  :      :    : :: :: '
echo -e '\e[0m'   

echo '=============== SETUP IS FINISHED ==================='

source $HOME/.bash_profile