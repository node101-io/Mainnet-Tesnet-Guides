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

cd $HOME && sudo apt update  &&  sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils htop -y < "/dev/null"

# Variables

APP=seid
CHAIN_ID=atlantic-1
PORT=56
SYSTEM_FOLDER=.sei
PROJECT_FOLDER=sei-chain
VERSION=origin/1.0.1beta-upgrade
REPO=https://github.com/sei-protocol/sei-chain
GENESIS_FILE=https://raw.githubusercontent.com/sei-protocol/testnet/main/sei-incentivized-testnet/genesis.json
ADDRBOOK=https://raw.githubusercontent.com/sei-protocol/testnet/main/sei-incentivized-testnet/addrbook.json
DENOM=usei
SEEDS=
PEERS=

sleep 2

echo "export APP=${APP}" >> $HOME/.bash_profile
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

ver="1.18.1"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile

sleep 1

git clone $REPO
cd $PROJECT_FOLDER
git checkout $VERSION ; make install
mv $HOME/go/bin/$APP /usr/bin/

sleep 1

$APP config chain-id $CHAIN_ID
$APP init $MONIKER --chain-id $CHAIN_ID

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

# Creating your systemd service

sudo tee /etc/systemd/system/$EXECUTE.service > /dev/null <<EOF
[Unit]
Description=Sei-Network Node
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/
ExecStart=/root/go/bin/seid start
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF


sudo systemctl daemon-reload
sudo systemctl enable $EXECUTE
sudo systemctl restart $EXECUTE
sudo systemctl restart systemd-journald

sleep 1 

echo -e '\e[0m'
echo -e ' @@@@@@   @@@@@@@@  @@@      @@@@@@   @@@@@@@  @@@        @@@@@@   @@@  @@@  @@@@@@@  @@@   @@@@@@@               @@@'
echo -e '@@@@@@@   @@@@@@@@  @@@     @@@@@@@@  @@@@@@@  @@@       @@@@@@@@  @@@@ @@@  @@@@@@@  @@@  @@@@@@@@              @@@@'
echo -e '!@@       @@!       @@!     @@!  @@@    @@!    @@!       @@!  @@@  @@!@!@@@    @@!    @@!  !@@                  @@@!!'
echo -e '!@!       !@!       !@!     !@!  @!@    !@!    !@!       !@!  @!@  !@!!@!@!    !@!    !@!  !@!                    !@!'
echo -e '!!@@!!    @!!!:!    !!@     @!@!@!@!    @!!    @!!       @!@!@!@!  @!@ !!@!    @!!    !!@  !@!       @!@!@!@!@    @!@'
echo -e ' !!@!!!   !!!!!:    !!!     !!!@!!!!    !!!    !!!       !!!@!!!!  !@!  !!!    !!!    !!!  !!!       !!!@!@!!!    !@!'
echo -e '     !:!  !!:       !!:     !!:  !!!    !!:    !!:       !!:  !!!  !!:  !!!    !!:    !!:  :!!                    !!:'
echo -e '    !:!   :!:       :!:     :!:  !:!    :!:     :!:      :!:  !:!  :!:  !:!    :!:    :!:  :!:                    :!:'
echo -e ':::: ::    :: ::::   ::     ::   :::     ::     :: ::::  ::   :::   ::   ::     ::     ::   ::: :::               :::'
echo -e '\e[0m'

echo '=============== SETUP IS FINISHED ==================='
echo -e "CHECK OUT YOUR LOGS : \e[1m\e[32mjournalctl -fu ${APP} -o cat\e[0m"
echo -e "CHECK SYNC: \e[1m\e[32mcurl -s localhost:${PORT}657/status | jq .result.sync_info\e[0m"
source $HOME/.bash_profile