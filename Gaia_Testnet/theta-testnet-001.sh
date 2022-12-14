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

##### CONFIGURATION ###

export GAIA_BRANCH=v7.0.0
export GENESIS_ZIPPED_URL=https://github.com/cosmos/testnets/raw/master/public/genesis.json.gz
export NODE_HOME=$HOME/.gaia
export SYSTEM_FOLDER=$HOME/.gaia
export CHAIN_ID=theta-testnet-001
export NODE_MONIKER=node101 # only really need to change this one
export BINARY=gaiad
export SEEDS="639d50339d7045436c756a042906b9a69970913f@seed-01.theta-testnet.polypore.xyz:26656,3e506472683ceb7ed75c1578d092c79785c27857@seed-02.theta-testnet.polypore.xyz:26656"

##### OPTIONAL STATE SYNC CONFIGURATION ###

export STATE_SYNC=true # if you set this to true, please have TRUST HEIGHT and TRUST HASH and RPC configured
export TRUST_HEIGHT=9500000
export TRUST_HASH="92ABB312DFFA04D3439C5A0F74A07F46843ADC4EB391A723EAE00855ADECF5A4"
export SYNC_RPC="rpc.sentry-01.theta-testnet.polypore.xyz:26657,rpc.sentry-02.theta-testnet.polypore.xyz:26657"

############## 

# you shouldn't need to edit anything below this

echo "Updating apt-get..."
sudo apt-get update

echo "Getting essentials..."
sudo apt-get install git build-essential ntp

echo "Installing go..."
wget -q -O - https://git.io/vQhTU | bash -s - --version 1.18

echo "Sourcing bashrc to get go in our path..."
source $HOME/.bashrc

export GOROOT=$HOME/.go
export PATH=$GOROOT/bin:$PATH
export GOPATH=/root/go
export PATH=$GOPATH/bin:$PATH

echo "Getting gaia..."
git clone https://github.com/cosmos/gaia.git

echo "cd into gaia..."
cd gaia

echo "checkout gaia branch..."
git checkout $GAIA_BRANCH

echo "building gaia..."
make install
echo "***********************"
echo "INSTALLED GAIAD VERSION"
gaiad version
echo "***********************"

cd ..
echo "getting genesis file"
wget $GENESIS_ZIPPED_URL
gunzip genesis.json.gz 

echo "configuring chain..."
$BINARY config chain-id $CHAIN_ID --home $SYSTEM_FOLDER
$BINARY config keyring-backend test --home $SYSTEM_FOLDER
$BINARY config broadcast-mode block --home $SYSTEM_FOLDER
$BINARY init $NODE_MONIKER --home $NODE_HOME --chain-id=$CHAIN_ID

if $STATE_SYNC; then
    echo "enabling state sync..."
    sed -i -e '/enable =/ s/= .*/= true/' $SYSTEM_FOLDER/config/config.toml
    sed -i -e "/trust_height =/ s/= .*/= $TRUST_HEIGHT/" $SYSTEM_FOLDER/config/config.toml
    sed -i -e "/trust_hash =/ s/= .*/= \"$TRUST_HASH\"/" $SYSTEM_FOLDER/config/config.toml
    sed -i -e "/rpc_servers =/ s/= .*/= \"$SYNC_RPC\"/" $SYSTEM_FOLDER/config/config.toml
else
    echo "disabling state sync..."
fi

echo "copying over genesis file..."
cp genesis.json $SYSTEM_FOLDER/config/genesis.json

echo "setup cosmovisor dirs..."
mkdir -p $BINARY/cosmovisor/genesis/bin

echo "copy binary over..."
cp $(which gaiad) $BINARY/cosmovisor/genesis/bin

echo "re-export binary"
export BINARY=$BINARY/cosmovisor/genesis/bin/gaiad

echo "install cosmovisor"
export GO111MODULE=on
go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

echo "setup systemctl"
touch /etc/systemd/system/$BINARY.service

echo "[Unit]"                               >> /etc/systemd/system/$BINARY.service
echo "Description=cosmovisor-$BINARY" >> /etc/systemd/system/$BINARY.service
echo "After=network-online.target"          >> /etc/systemd/system/$BINARY.service
echo ""                                     >> /etc/systemd/system/$BINARY.service
echo "[Service]"                            >> /etc/systemd/system/$BINARY.service
echo "User=root"                        >> /etc/systemd/system/$BINARY.service
echo "ExecStart=/root/go/bin/cosmovisor start --x-crisis-skip-assert-invariants --home \$DAEMON_HOME --p2p.seeds $SEEDS" >> /etc/systemd/system/$BINARY.service
echo "Restart=always"                       >> /etc/systemd/system/$BINARY.service
echo "RestartSec=3"                         >> /etc/systemd/system/$BINARY.service
echo "LimitNOFILE=4096"                     >> /etc/systemd/system/$BINARY.service
echo "Environment='DAEMON_NAME=gaiad'"      >> /etc/systemd/system/$BINARY.service
echo "Environment='DAEMON_HOME=$BINARY'" >> /etc/systemd/system/$BINARY.service
echo "Environment='DAEMON_ALLOW_DOWNLOAD_BINARIES=true'" >> /etc/systemd/system/$BINARY.service
echo "Environment='DAEMON_RESTART_AFTER_UPGRADE=true'" >> /etc/systemd/system/$BINARY.service
echo "Environment='DAEMON_LOG_BUFFER_SIZE=512'" >> /etc/systemd/system/$BINARY.service
echo ""                                     >> /etc/systemd/system/$BINARY.service
echo "[Install]"                            >> /etc/systemd/system/$BINARY.service
echo "WantedBy=multi-user.target"           >> /etc/systemd/system/$BINARY.service

echo "reload systemd..."
sudo systemctl daemon-reload

echo "starting the daemon..."
sudo systemctl start $BINARY.service

sudo systemctl restart systemd-journald

echo "***********************"
echo "find logs like this:"
echo "sudo journalctl -fu $BINARY.service"
echo "***********************"

echo -e '\033[0;95m'
echo -e ' @@@@@@@@   @@@@@@   @@@   @@@@@@ '
echo -e '@@@@@@@@@  @@@@@@@@  @@@  @@@@@@@@'
echo -e '!@@        @@!  @@@  @@!  @@!  @@@'
echo -e '!@!        !@!  @!@  !@!  !@!  @!@'
echo -e '!@! @!@!@  @!@!@!@!  !!@  @!@!@!@!'
echo -e '!!! !!@!!  !!!@!!!!  !!!  !!!@!!!!'
echo -e ':!!   !!:  !!:  !!!  !!:  !!:  !!!'
echo -e ':!:   !::  :!:  !:!  :!:  :!:  !:!'
echo -e ' ::: ::::  ::   :::   ::  ::   :::'
echo -e ' :: :: :    :   : :  :     :   : :'
echo -e '\033[0;95m'                              